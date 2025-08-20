{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../../home-manager/base
    ../../home-manager/server
  ];

  systemd.user.timers."obsidian-backup" = {
    Unit.Description = "Run obsidian-backup.sh every 10 minutes";
    Timer = {
      OnCalendar = "3:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  systemd.user.services."obsidian-backup" = {
    Unit.Description = "Run obsidian-backup.sh every 10 minutes";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash /home/${username}/backup/obsidian-backup.sh";
    };
  };
}
