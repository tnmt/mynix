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
  ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
      common-gpu-intel
      common-pc-ssd
    ]);

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    extraModprobeConfig = ''
      options iwlwifi disable_11ax=true
    '';
  };

  time.hardwareClockInLocalTime = true;

  # Don't touch this
  system.stateVersion = "22.11";

  users.users."${username}" = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
    ];
  };

  nix.settings.secret-key-files = "/etc/remotebuild/cache-priv-key.pem";
}
