{
  config,
  pkgs,
  ...
}:
let
  description = "Run obsidian backup daily at 3:00 AM";
in
{
  systemd.user = {
    timers.obsidian-backup = {
      Unit.Description = description;
      Timer = {
        OnCalendar = "3:00";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };

    services.obsidian-backup = {
      Unit.Description = description;
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash ${config.home.homeDirectory}/backup/obsidian-backup.sh";
      };
    };
  };
}
