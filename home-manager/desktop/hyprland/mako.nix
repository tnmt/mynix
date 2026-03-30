{ theme, ... }:
{
  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      default-timeout = 5000;
      width = 420;
      outer-margin = "20";
      padding = "10,15";
      border-size = 2;
      border-color = theme.accent;
      max-icon-size = 32;
      font = "sans-serif 14px";
      text-color = theme.foreground;
      background-color = theme.background;

      "mode=do-not-disturb" = {
        invisible = true;
      };

      "urgency=critical" = {
        default-timeout = 0;
        layer = "overlay";
      };
    };
  };
}
