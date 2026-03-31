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
    # atuin-server binary is named differently; skip shell completion generation
    postInstall = "";
  });
in
{
  imports = [
    ../../home-manager/base
    ../../home-manager/server
  ];

  custom = {
    email = ""; # set locally or via sops-nix
    name = "tnmt";
  };

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://tnmt.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "tnmt.cachix.org-1:TWp26nryyjLq7Xzyz7Hx81W7htBNcIMcbfHw+BrxtF8="
    ];
  };

  # atuin server (vps02 only)
  systemd.user.services.atuin-server = {
    Unit = {
      Description = "Atuin Sync Server";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${atuin-server}/bin/atuin server start";
      Restart = "on-failure";
      RestartSec = 5;
      Environment = [
        "ATUIN_HOST=127.0.0.1"
        "ATUIN_PORT=8888"
        "ATUIN_OPEN_REGISTRATION=false"
        "ATUIN_DB_URI=sqlite:///home/tnmt/.local/share/atuin-server/atuin.db"
      ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
