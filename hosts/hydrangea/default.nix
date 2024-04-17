{ ... }: {
  boot.loader.grub.enable = false;

  fileSystems."/" =
    { device = "/dev/sdd";
      fsType = "ext4";
    };

  users.users.tnmt = {
    isNormalUser = true;
    home = "/home/tnmt";
    shell = "zsh";
    group = [ "users", "wheel" ];
  };

  nix.settings.trusted-users = [ "tnmt" ];
}
