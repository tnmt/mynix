{ pkgs, config, ... }: {
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];
}
