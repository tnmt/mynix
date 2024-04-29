{
  inputs,
  pkgs,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/desktop
    ../../modules/programs/hyprland.nix
    ../../modules/programs/openssh.nix
    ../../modules/programs/shell.nix
    ../../modules/programs/virtualisation.nix
    ../../modules/programs/xserver.nix
    ../../modules/nixos
  ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
      common-gpu-intel
      common-pc-ssd
    ]);

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.extraModprobeConfig = ''
    options iwlwifi disable_11ax=true
  '';

  nix.settings.secret-key-files = "/etc/remotebuild/cache-priv-key.pem";
}
