{ theme, ... }:
let
  strip = color: builtins.substring 1 (-1) color;
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 5;
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
          outline_thickness = 2;
          outer_color = "rgb(${strip theme.foreground})";
          inner_color = "rgb(000000)";
          font_color = "rgb(${strip theme.foreground})";
          check_color = "rgb(828bb8)";
          fail_color = "rgb(${strip theme.color1})";
          fade_on_empty = true;
          placeholder_text = "";
          dots_spacing = 0.3;
          dots_size = 0.25;
          position = "0, -80";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME";
          font_size = 64;
          color = "rgb(${strip theme.foreground})";
          font_family = "Noto Sans CJK JP";
          position = "0, 60";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:60000] date +\"%Y-%m-%d\"";
          font_size = 20;
          color = "rgb(${strip theme.foreground})";
          font_family = "Noto Sans CJK JP";
          position = "0, 140";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
