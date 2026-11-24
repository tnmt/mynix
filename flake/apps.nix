{
  forAllSystems,
  pkgsFor,
  self,
}:
forAllSystems (
  system:
  let
    pkgs = pkgsFor system;
    rebuildCmd = if pkgs.lib.hasSuffix "darwin" system then "darwin" else "os";
    switch = pkgs.writeShellApplication {
      name = "switch";
      runtimeInputs = [ pkgs.nh ];
      text = ''
        host="''${HOSTNAME:-$(uname -n)}"
        host="''${host%%.*}"
        exec nh ${rebuildCmd} switch . -H "$host" "$@"
      '';
    };
    # switch が通った lock だけを commit / push する。作業ツリーに未コミットの
    # 変更があると switch の評価に混ざるので、その場合は何もせず止める。
    update = pkgs.writeShellApplication {
      name = "update";
      runtimeInputs = [ pkgs.git ];
      text = ''
        cd "$(git rev-parse --show-toplevel)"

        if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
          echo "update: working tree has uncommitted changes; commit or stash them first" >&2
          exit 1
        fi

        nix flake update

        if git diff --quiet -- flake.lock; then
          echo "update: flake.lock unchanged; nothing to switch or commit"
          exit 0
        fi

        ${switch}/bin/switch "$@"

        git add flake.lock
        git commit -m "chore: flake update $(date '+%Y-%m-%d %H:%M')"
        git push
      '';
    };
  in
  {
    # Extra args after `--` pass through to nh.
    switch = {
      type = "app";
      program = "${switch}/bin/switch";
      meta.description = "Rebuild & activate current host (auto-detect NixOS/Darwin)";
    };
    # Extra args after `--` pass through to switch (and on to nh).
    update = {
      type = "app";
      program = "${update}/bin/update";
      meta.description = "Update flake inputs, switch current host, then commit & push flake.lock";
    };
  }
  // pkgs.lib.optionalAttrs (system == "x86_64-linux") {
    dahlia-vm = {
      type = "app";
      program = "${self.nixosConfigurations.dahlia.config.system.build.vm}/bin/run-dahlia-vm";
      meta.description = "Run dahlia NixOS VM";
    };
  }
)
