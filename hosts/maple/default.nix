{ pkgs, config, ... }: {
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "maple";
}
