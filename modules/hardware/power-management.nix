# Common settings for NixOS laptops
# - Power management via power-profiles-daemon
# - Battery: auto-disable turbo boost via udev
{ pkgs, ... }:
{
  services = {
    logind = {
      # Keep the system awake when the laptop lid is closed while docked
      # or driving an external display.
      settings.Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchDocked = "ignore";
      };
    };

    power-profiles-daemon.enable = true;
    upower.enable = true;

    udev.extraRules = ''
      SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.bash}/bin/bash -c 'echo 0 > /sys/devices/system/cpu/cpufreq/boost'"
      SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.bash}/bin/bash -c 'echo 1 > /sys/devices/system/cpu/cpufreq/boost'"

      # Recent systemd/logind stopped granting the seat-active user a dynamic
      # uaccess ACL on backlight devices (brightness is meant to go through
      # logind's D-Bus API instead; re-adding TAG+="uaccess" alone was verified
      # NOT to restore it on this system). Noctalia's own brightness control
      # still writes sysfs directly and fails with EACCES without write access,
      # so fall back to the classic static group grant instead.
      SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';
  };
}
