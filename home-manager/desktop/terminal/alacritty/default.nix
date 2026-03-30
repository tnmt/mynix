{ pkgs, theme, ... }:
let
  fontsize = if pkgs.stdenv.isDarwin then 16 else 12;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  programs.alacritty = {
    enable = true;

    settings = {
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
        size = fontsize;
        normal = {
          family = "MesloLGS Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "MesloLGS Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "MesloLGS Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "MesloLGS Nerd Font";
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

      colors = {
        primary = {
          background = theme.background;
          foreground = theme.foreground;
        };
        normal = {
          black = theme.color0;
          red = theme.color1;
          green = theme.color2;
          yellow = theme.color3;
          blue = theme.color4;
          magenta = theme.color5;
          cyan = theme.color6;
          white = theme.color7;
        };
        bright = {
          black = theme.color8;
          red = theme.color9;
          green = theme.color10;
          yellow = theme.color11;
          blue = theme.color12;
          magenta = theme.color13;
          cyan = theme.color14;
          white = theme.color15;
        };
      };

      keyboard.bindings = [
        { key = "N"; mods = "Control|Shift"; action = "SpawnNewInstance"; }
        { key = "V"; mods = "Control|Shift"; action = "Paste"; }
        { key = "C"; mods = "Control|Shift"; action = "Copy"; }
        { key = "Plus"; mods = "Control"; action = "IncreaseFontSize"; }
        { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
        { key = "Key0"; mods = "Control"; action = "ResetFontSize"; }
      ];
    };
  };
}
