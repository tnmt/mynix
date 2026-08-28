# Shared option schema for the shizuku local memory server.
# OS-specific wiring lives in
# modules/{darwin,nixos}/services/shizuku.nix, which import this file
# and register a launchd agent (Darwin) or systemd user unit (NixOS)
# pointing at `cfg.package/bin/shizuku-server`.
#
# mynix intentionally does not know how to fetch the shizuku sources.
# `cfg.package` is required from the consumer flake so no reference
# to the shizuku input leaks into this repository.
{
  config,
  lib,
  ...
}:
let
  cfg = config.mynix.services.shizuku;
in
{
  options.mynix.services.shizuku = {
    enable = lib.mkEnableOption "shizuku local memory server";

    package = lib.mkOption {
      type = lib.types.package;
      description = ''
        The `shizuku-server` derivation to run. Callers pass this in as
        `inputs.shizuku.packages.<system>.default` from the flake that
        owns the shizuku input.
      '';
    };

    repoPath = lib.mkOption {
      type = lib.types.str;
      example = "/Users/tsunematsu/ghq/github.com/tnmt/shizuku";
      description = ''
        Absolute path to a shizuku working tree (where `pyproject.toml`
        lives). `shizuku-server` cd's into this directory and runs
        `uv sync --locked` from it. The path is not baked into the
        derivation so each host may keep the checkout wherever it likes.
      '';
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Bind address. Keep on loopback per shizuku safety guidance.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 7820;
    };

    logDir = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Directory to write `shizuku.log` into. Only consulted on Darwin
        (StandardOutPath / StandardErrorPath). On NixOS logs go to
        journald and this option is ignored.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.repoPath != "";
        message = "mynix.services.shizuku.repoPath must be set when the service is enabled.";
      }
    ];
  };
}
