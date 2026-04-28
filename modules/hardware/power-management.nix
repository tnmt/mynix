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

    # バッテリー駆動時にターボブーストを自動無効化、AC接続時に再有効化
    udev.extraRules = ''
      SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.bash}/bin/bash -c 'echo 0 > /sys/devices/system/cpu/cpufreq/boost'"
      SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.bash}/bin/bash -c 'echo 1 > /sys/devices/system/cpu/cpufreq/boost'"
    '';
  };
}
