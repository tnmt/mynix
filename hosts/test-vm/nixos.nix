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

  users.users."${username}".initialPassword = "test";

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
