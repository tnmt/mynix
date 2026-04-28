{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.maestral ];

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

  systemd.user.services.maestral = {
    Unit = {
      Description = "Maestral Dropbox client";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      ExecStart = "${pkgs.maestral}/bin/maestral start -f";
      ExecStop = "${pkgs.maestral}/bin/maestral stop";
      Restart = "on-failure";
      Type = "notify";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
