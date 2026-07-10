{ theme, ... }:
let
  fonts = import ../fonts.nix;

  strip = color: builtins.substring 1 (-1) color;
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
      };

      background = [
        {
          monitor = "";
          blur_passes = 3;
          blur_size = 5;
          brightness = 0.5;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "300, 50";
          outline_thickness = 3;
          rounding = 40;
          outer_color = "rgb(${strip theme.accent})";
          inner_color = "rgb(${strip theme.bg_dark})";
          font_color = "rgb(${strip theme.foreground})";
          check_color = "rgb(${strip theme.accent})";
          fail_color = "rgb(${strip theme.color1})";
          fail_text = "$FAIL";
          fade_on_empty = true;
          placeholder_text = "";
          dots_spacing = 0.3;
          dots_size = 0.25;
          position = "0, -80";
          halign = "center";
          valign = "center";
          shadow_passes = 3;
          shadow_size = 12;
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME";
          font_size = 64;
          color = "rgb(${strip theme.foreground})";
          font_family = fonts.sans;
          position = "0, 60";
          halign = "center";
          valign = "center";
          shadow_passes = 5;
          shadow_size = 10;
        }
        {
          monitor = "";
          text = "cmd[update:60000] date +\"%Y-%m-%d\"";
          font_size = 20;
          color = "rgb(${strip theme.comment})";
          font_family = fonts.sans;
          position = "0, 140";
          halign = "center";
          valign = "center";
          shadow_passes = 5;
          shadow_size = 10;
        }
      ];
    };
  };
}
