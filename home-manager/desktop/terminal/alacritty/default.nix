{
  pkgs,
  lib,
  terminal,
  theme,
  ...
}:
let
  themeSrc = theme.srcDrv pkgs;
  themeColors = builtins.fromTOML (builtins.readFile "${themeSrc}/${theme.extras.alacritty}");
in
{
  programs.alacritty = {
    enable = true;

    settings = lib.recursiveUpdate themeColors {
      env.TERM = "xterm-256color";

      window = {
        blur = true;
        decorations = "full";
        dynamic_padding = false;
        opacity = 0.95;
        startup_mode = "Windowed";
        padding = {
          x = 5;
          y = 5;
        };
      };

      font = {
        inherit (terminal.font) size;
        normal = {
          family = terminal.font.name;
          style = "Regular";
        };
        bold = {
          family = terminal.font.name;
          style = "Bold";
        };
        italic = {
          family = terminal.font.name;
          style = "Italic";
        };
        bold_italic = {
          family = terminal.font.name;
          style = "Bold Italic";
        };
      };

      scrolling = {
        history = 100000;
        multiplier = 3;
      };

      selection.save_to_clipboard = true;

      cursor = {
        style = {
          shape = "Block";
          blinking = "Off";
        };
        vi_mode_style = {
          shape = "Block";
          blinking = "Off";
        };
        unfocused_hollow = true;
      };

      bell = {
        animation = "EaseOutExpo";
        duration = 0;
        color = "#ffffff";
      };

      mouse.hide_when_typing = false;

      keyboard.bindings = [
        {
          key = "N";
          mods = "Control|Shift";
          action = "SpawnNewInstance";
        }
        {
          key = "V";
          mods = "Control|Shift";
          action = "Paste";
        }
        {
          key = "C";
          mods = "Control|Shift";
          action = "Copy";
        }
        {
          key = "Plus";
          mods = "Control";
          action = "IncreaseFontSize";
        }
        {
          key = "Minus";
          mods = "Control";
          action = "DecreaseFontSize";
        }
        {
          key = "Key0";
          mods = "Control";
          action = "ResetFontSize";
        }
      ];
    };
  };
}
