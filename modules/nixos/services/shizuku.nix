# NixOS backend for mynix.services.shizuku: shared options live in
# modules/common/shizuku.nix. Registers a systemd user unit that keeps
# the local memory server running.
#
# Requires the target user to have `users.users.<user>.linger = true`
# so the unit starts at boot rather than only after login.
{
  config,
  lib,
  pkgs,
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
        # shizuku-server's wrapper pins UV_PYTHON to a Nix-built interpreter
        # (UV_PYTHON_PREFERENCE=only-system), so `uv sync` runs under a
        # genuine Nix Python rather than an FHS-assuming portable build —
        # nix-ld's interpreter shim never enters the picture. But the PyPI
        # wheels it installs (numpy, transformers, ...) still ship manylinux
        # C extensions that dlopen() libstdc++.so.6 at import time, which
        # isn't part of that Python's closure. Point dlopen at one via
        # LD_LIBRARY_PATH.
        LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib ];
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
