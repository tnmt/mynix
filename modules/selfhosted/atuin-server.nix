{ pkgs, ... }:
let
  atuin-server = pkgs.atuin.overrideAttrs (old: {
    pname = "atuin-server";
    cargoBuildFlags = [
      "--package"
      "atuin-server"
    ];
    cargoBuildFeatures = [ ];
    cargoCheckFeatures = [ ];
    doCheck = false;
    postInstall = "";
  });
in
{
  systemd.services.atuin-server = {
    description = "Atuin Sync Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${atuin-server}/bin/atuin-server start";
      Restart = "on-failure";
      RestartSec = 5;
      StateDirectory = "atuin-server";
      ConfigurationDirectory = "atuin";
      DynamicUser = true;
    };
    environment = {
      HOME = "/var/lib/atuin-server";
      ATUIN_HOST = "127.0.0.1";
      ATUIN_PORT = "8888";
      ATUIN_OPEN_REGISTRATION = "false";
      ATUIN_DB_URI = "sqlite:///var/lib/atuin-server/atuin.db";
    };
  };
}
