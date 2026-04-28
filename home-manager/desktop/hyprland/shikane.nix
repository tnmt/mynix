_: {
  services.shikane = {
    enable = true;
    settings = {
      profile = [
        {
          name = "undocked";
          output = [
            {
              match = "eDP-1";
              enable = true;
              mode = "1920x1080@60";
              position = "0,0";
              scale = 1.0;
            }
          ];
        }
        {
          name = "homelab";
          output = [
            {
              match = "eDP-1";
              enable = false;
            }
            {
              match = "DP-1";
              enable = true;
              mode = "3840x2160@60";
              position = "0,0";
              scale = 1.25;
            }
          ];
        }
      ];
    };
  };
}
