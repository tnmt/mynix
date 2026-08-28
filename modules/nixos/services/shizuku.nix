# NixOS backend for mynix.services.shizuku: shared options live in
# modules/common/shizuku.nix. Registers a systemd user unit that keeps
# the local memory server running.
#
# Requires the target user to have `users.users.<user>.linger = true`
# so the unit starts at boot rather than only after login.
{
  config,
  lib,
  ...
}:
let
  cfg = config.mynix.services.shizuku;
in
{
  imports = [ ../../common/shizuku.nix ];

  config = lib.mkIf cfg.enable {
    systemd.user.services.shizuku = {
      description = "shizuku local memory server";
      wantedBy = [ "default.target" ];
      environment = {
        SHIZUKU_REPO = cfg.repoPath;
        SHIZUKU_HOST = cfg.host;
        SHIZUKU_PORT = toString cfg.port;
      };
      serviceConfig = {
        Type = "exec";
        ExecStart = "${cfg.package}/bin/shizuku-server";
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };
  };
}
