{ config, pkgs, ... }:
let
  dropboxDir = "${config.home.homeDirectory}/Dropbox";
  remoteParent = "/my-files";
  remoteName = "Dropbox-backup";
  stateDir = "${config.xdg.stateHome}/proton-drive-backup";

  # Rendered from sops (mynix.profiles.userTemplates.protonDriveBackup)
  # because the directory names reveal personal content. One path per line,
  # relative to ~/Dropbox; each entry is split into chunks (see chunks()
  # below) and uploaded under the remote root.
  includeFile = "${config.xdg.configHome}/proton-drive-backup/include";

  backup = pkgs.writeShellApplication {
    name = "proton-drive-backup";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.findutils
      pkgs.gnugrep
      pkgs.proton-drive-cli
      pkgs.systemd
    ];
    text = ''
      # Credentials live in gnome-keyring, which only exists inside a
      # graphical login; fail loudly instead of letting the CLI prompt.
      if ! busctl --user status org.freedesktop.secrets >/dev/null 2>&1; then
        echo "secret-service (org.freedesktop.secrets) is not available; is the user logged in?" >&2
        exit 1
      fi

      if [[ ! -s "${includeFile}" ]]; then
        echo "${includeFile} is missing or empty" >&2
        exit 1
      fi

      mkdir -p "${stateDir}"
      signature_file="${stateDir}/chunk-signatures"
      touch "$signature_file"

      mapfile -t includes < <(grep -v -e '^[[:space:]]*$' -e '^#' "${includeFile}")

      remote="${remoteParent}/${remoteName}"
      if ! proton-drive filesystem info "$remote" >/dev/null 2>&1; then
        proton-drive filesystem create-folder "${remoteParent}" "${remoteName}"
      fi

      # Splits each top-level include entry into chunks of at most two
      # directory levels (e.g. Archive/2020 rather than all of Archive in
      # one upload call), printed as TYPE<TAB>REL lines. A directory with
      # no subdirectories -- at the top level or one level down -- becomes
      # a single PATH chunk (REL names the path itself, relative to
      # ~/Dropbox, uploaded recursively). One with subdirectories one level
      # down contributes each of those as its own PATH chunk, plus -- if
      # any files sit alongside them -- one FILES chunk (REL names the
      # containing directory; its direct files are uploaded together in a
      # single call, not recursed into). This bounds how much work a
      # transient per-file failure or an interrupted run can cost: only the
      # chunk in progress, not every other folder.
      chunks() {
        for path in "''${includes[@]}"; do
          full="${dropboxDir}/$path"
          [[ -e "$full" ]] || continue
          if [[ ! -d "$full" ]]; then
            printf 'PATH\t%s\n' "$path"
            continue
          fi
          if [[ -z "$(find "$full" -mindepth 1 -maxdepth 1 -print -quit)" ]]; then
            printf 'PATH\t%s\n' "$path"
            continue
          fi
          while IFS= read -r d1; do
            rel1="''${d1#"${dropboxDir}"/}"
            if [[ -z "$(find "$d1" -mindepth 1 -maxdepth 1 -type d -print -quit)" ]]; then
              printf 'PATH\t%s\n' "$rel1"
              continue
            fi
            while IFS= read -r d2; do
              printf 'PATH\t%s\n' "''${d2#"${dropboxDir}"/}"
            done < <(find "$d1" -mindepth 1 -maxdepth 1 -type d | sort)
            if [[ -n "$(find "$d1" -mindepth 1 -maxdepth 1 -type f -print -quit)" ]]; then
              printf 'FILES\t%s\n' "$rel1"
            fi
          done < <(find "$full" -mindepth 1 -maxdepth 1 -type d | sort)
          if [[ -n "$(find "$full" -mindepth 1 -maxdepth 1 -type f -print -quit)" ]]; then
            printf 'FILES\t%s\n' "$path"
          fi
        done
      }

      # A chunk's signature is the sorted (mtime, size, path) of every file
      # under it (direct files only for a FILES chunk). Unchanged chunks are
      # skipped before any network call, which is what makes day-to-day runs
      # fast: most of a photo archive never changes once written. A chunk
      # that succeeds gets its signature updated immediately, so re-running
      # after an interruption (a reboot mid-upload) also skips whatever
      # already finished -- no separate resume state needed.
      exit_code=0
      declare -A ensured
      while IFS=$'\t' read -r type rel; do
        full="${dropboxDir}/$rel"
        if [[ "$type" == "FILES" ]]; then
          find_args=(-mindepth 1 -maxdepth 1 -type f)
          parent_rel="$rel"
        else
          find_args=(-type f)
          parent_rel="''${rel%/*}"
          [[ "$parent_rel" == "$rel" ]] && parent_rel="."
        fi
        sig="$(find "$full" "''${find_args[@]}" -printf '%T@ %s %p\n' 2>/dev/null | sort | sha256sum | cut -d' ' -f1)"
        key="$type"$'\t'"$rel"
        prev_sig="$(grep -F "$key"$'\t' "$signature_file" 2>/dev/null | tail -n1 | cut -f3)" || true
        if [[ -n "$prev_sig" && "$prev_sig" == "$sig" ]]; then
          continue
        fi

        if [[ "$parent_rel" != "." && -z "''${ensured["$parent_rel"]:-}" ]]; then
          cur="$remote"
          accum=""
          IFS='/' read -ra parts <<< "$parent_rel"
          for part in "''${parts[@]}"; do
            accum="''${accum:+$accum/}$part"
            if [[ -z "''${ensured["$accum"]:-}" ]]; then
              next="$cur/$part"
              if ! proton-drive filesystem info "$next" >/dev/null 2>&1; then
                proton-drive filesystem create-folder "$cur" "$part"
              fi
              ensured["$accum"]=1
            fi
            cur="$cur/$part"
          done
        fi

        dest="$remote"
        [[ "$parent_rel" != "." ]] && dest="$remote/$parent_rel"

        # Upload-only: local deletions are never propagated, and changed
        # files become new revisions, so the copy survives mistakes on the
        # Dropbox side.
        ok=1
        if [[ "$type" == "FILES" ]]; then
          mapfile -t file_args < <(find "$full" -mindepth 1 -maxdepth 1 -type f | sort)
          if [[ ''${#file_args[@]} -eq 0 ]]; then
            continue
          fi
          proton-drive filesystem upload \
            --file-conflict-strategy create-new-revision \
            --folder-conflict-strategy merge \
            "''${file_args[@]}" "$dest" || ok=0
        else
          proton-drive filesystem upload \
            --file-conflict-strategy create-new-revision \
            --folder-conflict-strategy merge \
            "$full" "$dest" || ok=0
        fi

        if [[ "$ok" == 1 ]]; then
          grep -vF "$key"$'\t' "$signature_file" > "$signature_file.tmp" 2>/dev/null || true
          printf '%s\t%s\n' "$key" "$sig" >> "$signature_file.tmp"
          mv "$signature_file.tmp" "$signature_file"
        else
          echo "chunk failed, will retry next run: $type $rel" >&2
          exit_code=1
        fi
      done < <(chunks)

      exit "$exit_code"
    '';
  };
in
{
  home.packages = [ pkgs.proton-drive-cli ];

  systemd.user.services.proton-drive-backup = {
    Unit.Description = "Upload irreplaceable Dropbox data to Proton Drive";
    Service = {
      Type = "oneshot";
      ExecStart = "${backup}/bin/proton-drive-backup";
      Environment = [ "PROTON_DRIVE_LOG_LEVEL=INFO" ];
      Nice = 19;
      IOSchedulingClass = "idle";
    };
  };

  systemd.user.timers.proton-drive-backup = {
    Unit.Description = "Daily Proton Drive backup of Dropbox";
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
