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
        fcitx5-tokyonight
        qt6Packages.fcitx5-configtool
      ];
      settings.inputMethod = {
        "Groups/0" = {
          "Name" = "Default";
          "Default Layout" = "us";
          "DefaultIM" = "mozc";
        };
        "Groups/0/Items/0" = {
          "Name" = "keyboard-us";
        };
        "Groups/0/Items/1" = {
          "Name" = "mozc";
        };
        "GroupOrder" = {
          "0" = "Default";
        };
      };
      settings.addons.classicui.globalSection = {
        "Font" = "MesloLGS NF 10";
        "MenuFont" = "Noto Sans CJK JP 10";
        "Theme" = "Tokyonight-Storm";
        "DarkTheme" = "Tokyonight-Storm";
        "UseDarkTheme" = true;
      };
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
