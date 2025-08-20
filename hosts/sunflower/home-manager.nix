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
    Unit.Description = "Run obsidian backup daily at 3:00 AM";
    Timer = {
      OnCalendar = "3:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  systemd.user.services."obsidian-backup" = {
    Unit.Description = "Run obsidian backup daily at 3:00 AM";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash /home/${username}/backup/obsidian-backup.sh";
    };
  };
}
