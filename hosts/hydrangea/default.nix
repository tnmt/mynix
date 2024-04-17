{ pkgs, ... }: {
  imports = [ ../../modules/base ];

  boot.loader.grub.enable = false;

  programs.zsh.enable = true;

  fileSystems."/" =
    { device = "/dev/sdd";
      fsType = "ext4";
    };

  users.users.tnmt = {
    isNormalUser = true;
    home = "/home/tnmt";
    shell = pkgs.zsh;
    group = "users";
    extraGroups = ["wheel"];
  };

  nix.settings.trusted-users = [ "tnmt" ];

  networking.hostName = "hydrangea";
}
