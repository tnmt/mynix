# Darwin backend for mynix.services.shizuku: shared options live in
# modules/common/shizuku.nix. Registers a per-user LaunchAgent that
# keeps the local memory server running.
{
  config,
  lib,
  ...
}:
let
  cfg = config.mynix.services.shizuku;

  logPaths = lib.optionalAttrs (cfg.logDir != null) {
    StandardOutPath = "${cfg.logDir}/shizuku.log";
    StandardErrorPath = "${cfg.logDir}/shizuku.log";
  };
in
{
  imports = [ ../../common/shizuku.nix ];

  config = lib.mkIf cfg.enable {
    launchd.user.agents.shizuku = {
      serviceConfig = {
        Label = "info.tnmt.shizuku";
        ProgramArguments = [ "${cfg.package}/bin/shizuku-server" ];
        RunAtLoad = true;
        KeepAlive = true;
        ProcessType = "Background";
        EnvironmentVariables = {
          SHIZUKU_REPO = cfg.repoPath;
          SHIZUKU_HOST = cfg.host;
          SHIZUKU_PORT = toString cfg.port;
        };
      }
      // logPaths;
    };
  };
}
