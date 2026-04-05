{
  config,
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
    ../../home-manager/base-nixos
    ../../home-manager/devel
  ];

  custom = {
    email = ""; # set locally or via sops-nix
    name = "tnmt";
  };

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
