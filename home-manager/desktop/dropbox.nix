{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.dropbox ];

  home.activation.dropboxCoW = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "$HOME/Dropbox" ]; then
      if [ "$(${pkgs.coreutils}/bin/stat -f -c %T "$HOME" 2>/dev/null)" = "btrfs" ]; then
        $DRY_RUN_CMD ${pkgs.btrfs-progs}/bin/btrfs subvolume create "$HOME/Dropbox"
      else
        $DRY_RUN_CMD mkdir -p "$HOME/Dropbox"
      fi
      $DRY_RUN_CMD ${pkgs.e2fsprogs}/bin/chattr +C "$HOME/Dropbox" || true
    fi
  '';

  systemd.user.services.dropbox = {
    Unit = {
      Description = "Dropbox official daemon";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.dropbox}/bin/dropbox";
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      KillMode = "control-group";
      Restart = "on-failure";
      Nice = "10";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
