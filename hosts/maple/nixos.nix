{
  inputs,
  pkgs,
  username,
  ...
}: {
  imports = [
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
  nix.settings.trusted-users = [
    "root"
    "nixremote"
  ];

  programs.hyprland = {
    enable = true;
  };

  networking.hostName = "maple";
}
