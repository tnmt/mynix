{
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../../modules/core
    ../../modules/programs/shell.nix

  ];

  # VM-specific hardware
  fileSystems."/" = {
    device = "/dev/vda";
    fsType = "ext4";
  };
  boot.loader.grub.device = "/dev/vda";

  # User
  users.users."${username}" = {
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.zsh;
    group = "users";
    extraGroups = [ "wheel" ];
    initialPassword = "test";
  };

  home-manager.users."${username}" = import ./home-manager.nix;

  # VM niceties
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 2048;
      cores = 2;
      graphics = false;
    };
  };

  # Auto-login for convenience
  services.getty.autologinUser = username;
}
