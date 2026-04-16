{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  obsidianBackup = {
    description = "Run obsidian backup daily at 3:00 AM";
    scriptPath = "${config.home.homeDirectory}/backup/obsidian-backup.sh";
    schedule = "3:00";
  };
in
{
  imports = [
    ../../profiles/home-manager/nixos-development.nix
  ];

  # Disable home-manager sops (WSL has no user systemd; secrets are managed
  # at the NixOS system level in sunflower/nixos.nix instead)
  sops.secrets = lib.mkForce { };
  sops.templates = lib.mkForce { };

  systemd.user = {
    timers.obsidian-backup = {
      Unit.Description = obsidianBackup.description;
      Timer = {
        OnCalendar = obsidianBackup.schedule;
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };

    services.obsidian-backup = {
      Unit.Description = obsidianBackup.description;
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash ${obsidianBackup.scriptPath}";
      };
    };

  };
}
