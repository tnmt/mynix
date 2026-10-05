{ config, pkgs, ... }:
let
  dropboxDir = "${config.home.homeDirectory}/Dropbox";
  remoteParent = "/my-files";
  remoteName = "Dropbox-backup";

  # Rendered from sops (mynix.profiles.userTemplates.protonDriveBackup)
  # because the directory names reveal personal content. One path per line,
  # relative to ~/Dropbox; each entry is uploaded as a direct child of the
  # remote root.
  includeFile = "${config.xdg.configHome}/proton-drive-backup/include";

  backup = pkgs.writeShellApplication {
    name = "proton-drive-backup";
    runtimeInputs = [
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

      mapfile -t includes < <(grep -v -e '^[[:space:]]*$' -e '^#' "${includeFile}")

      remote="${remoteParent}/${remoteName}"
      if ! proton-drive filesystem info "$remote" >/dev/null 2>&1; then
        proton-drive filesystem create-folder "${remoteParent}" "${remoteName}"
      fi

      # Upload-only: local deletions are never propagated, and changed files
      # become new revisions, so the copy survives mistakes on the Dropbox side.
      for path in "''${includes[@]}"; do
        proton-drive filesystem upload \
          --file-conflict-strategy create-new-revision \
          --folder-conflict-strategy merge \
          "${dropboxDir}/$path" "$remote"
      done
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
