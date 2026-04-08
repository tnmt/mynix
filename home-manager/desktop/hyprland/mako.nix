{ theme, ... }:
let
  fonts = import ../fonts.nix;
in
{
  # Notification daemon — started on-demand via D-Bus activation
  # (not in exec-once; launched automatically when an app sends a notification)
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
      font = "${fonts.sans} 14px";
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
