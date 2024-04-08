{ pkgs, config, ... }: {
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];

  networking.hostName = "maple";

  nix.config.secret-key-files = "/etc/remotebuild/cache-priv-key.pem";
}
