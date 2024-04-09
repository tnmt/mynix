{ pkgs, config, ... }: {
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings.secret-key-files = "/etc/remotebuild/cache-priv-key.pem";

  networking.hostName = "maple";
}
