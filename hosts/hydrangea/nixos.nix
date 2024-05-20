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
    ../../modules/programs/openssh.nix

    inputs.nixos-wsl.nixosModules.default
  ];

  boot.loader.grub.enable = false;

  fileSystems."/" = {
    device = "/dev/sdd";
    fsType = "ext4";
  };

  users.users."${username}" = {
    isNormalUser = true;
    home = "/home/tnmt";
    shell = pkgs.zsh;
    group = "users";
    extraGroups = [ "wheel" ];
  };

  nix.settings.secret-key-files = "/etc/remotebuild/cache-priv-key.pem";
}
