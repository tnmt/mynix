{ pkgs, lib, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        qt6Packages.fcitx5-configtool
      ];
      settings.globalOptions = {
        "Hotkey/ActivateKeys" = {
          "0" = "Henkan";
        };
        "Hotkey/DeactivateKeys" = {
          "0" = "Muhenkan";
        };
        "Hotkey/TriggerKeys" = {
          "0" = "Control+space";
        };
      };
    };
  };
}
