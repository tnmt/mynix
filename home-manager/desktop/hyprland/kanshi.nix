{ ... }:
{
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            mode = "1920x1080";
            position = "0,0";
            scale = 1.0;
          }
        ];
      }
      {
        profile.name = "homelab";
        profile.outputs = [
          {
            criteria = "eDP-1";
            mode = "1920x1080";
            position = "0,0";
            scale = 1.0;
          }
          {
            criteria = "Dell Inc. DELL U2723QE B9G42P3";
            mode = "3840x2160";
            position = "1920,0";
            scale = 1.25;
          }
        ];
      }
    ];
  };
}
