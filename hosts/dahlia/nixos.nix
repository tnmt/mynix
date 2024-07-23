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
    home = "/home/${username}";
    shell = pkgs.zsh;
    group = "users";
    extraGroups = [ "wheel" ];
  };

  systemd.timers."obsidian-backup" = {
    description = "Run obsidian-backup.sh every 10 minutes";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "3:00";
      Persistent = true;
    };
  };

  systemd.services."obsidian-backup" = {
    description = "Run obsidian-backup.sh every 10 minutes";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash /home/${username}/backup/obsidian-backup.sh";
      User = "${username}";
    };
    wantedBy = [ "multi-user.target" ];
  };

  nix.settings.secret-key-files = "/etc/remotebuild/cache-priv-key.pem";
}
