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
    # shizuku-server runs `uv sync`, which fetches prebuilt Python wheels
    # (numpy, torch, etc.) linked against FHS-standard paths like
    # libstdc++.so.6. NixOS has no such paths, so their C extensions fail
    # to import without nix-ld providing a compatible dynamic linker.
    programs.nix-ld.enable = true;

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
