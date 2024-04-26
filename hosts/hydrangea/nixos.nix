{ pkgs, ... }: {
  imports = [ ../../modules/base ];

  boot.loader.grub.enable = false;

  programs.zsh.enable = true;
  programs.ssh.startAgent = true;

  fileSystems."/" =
    { device = "/dev/sdd";
      fsType = "ext4";
    };

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  users.users.tnmt = {
    isNormalUser = true;
    home = "/home/tnmt";
    shell = pkgs.zsh;
    group = "users";
    extraGroups = ["wheel"];
  };

  services.openssh = {
    enable = true;
  };

  nix.settings.secret-key-files = "/etc/remotebuild/cache-priv-key.pem";
  nix.settings.trusted-users = [
    "root"
    "nixremote"
    "tnmt"
  ];

  networking.hostName = "hydrangea";
}
