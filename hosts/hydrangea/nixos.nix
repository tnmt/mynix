{ pkgs, username, ... }: {
  imports = [
    ../../modules/core
    ../../modules/programs/shell.nix
    ../../modules/programs/openssh.nix
  ];

  boot.loader.grub.enable = false;

  programs.zsh.enable = true;
  programs.ssh.startAgent = true;

  fileSystems."/" =
    { device = "/dev/sdd";
      fsType = "ext4";
    };

  users.users."${username}" = {
    isNormalUser = true;
    home = "/home/tnmt";
    shell = pkgs.zsh;
    group = "users";
    extraGroups = ["wheel"];
  };

  nix.settings.secret-key-files = "/etc/remotebuild/cache-priv-key.pem";
}
