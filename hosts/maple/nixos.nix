{
  inputs,
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../modules/core
    ../../modules/programs/shell.nix
    ../../modules/programs/hyprland.nix
    ../../modules/nixos

    ./hardware-configuration.nix
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
