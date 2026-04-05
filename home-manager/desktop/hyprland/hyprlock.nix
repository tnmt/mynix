{ ... }:
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
          outer_color = "rgb(c8d3f5)";
          inner_color = "rgb(000000)";
          font_color = "rgb(c8d3f5)";
          check_color = "rgb(828bb8)";
          fail_color = "rgb(ff757f)";
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
          color = "rgb(c8d3f5)";
          font_family = "Noto Sans CJK JP";
          position = "0, 60";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:3600000] date +\"%a, %b %d\"";
          font_size = 20;
          color = "rgb(c8d3f5)";
          font_family = "Noto Sans CJK JP";
          position = "0, 140";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
