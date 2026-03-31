{ lib, theme, ... }:
{
  wayland.windowManager.hyprland.settings = {
    "$terminal" = "alacritty";
    "$menu" = "walker";
    "$browser" = "brave";

    monitor = ", preferred, auto, auto";

    env = [
      "XCURSOR_SIZE, 24"
      "HYPRCURSOR_SIZE, 24"
      "GDK_BACKEND, wayland,x11,*"
      "QT_QPA_PLATFORM, wayland;xcb"
      "SDL_VIDEODRIVER, wayland,x11"
      "MOZ_ENABLE_WAYLAND, 1"
      "ELECTRON_OZONE_PLATFORM_HINT, wayland"
      "XDG_CURRENT_DESKTOP, Hyprland"
      "XDG_SESSION_DESKTOP, Hyprland"
      "XDG_SESSION_TYPE, wayland"
      "XMODIFIERS, @im=fcitx"
      "INPUT_METHOD, fcitx"
      "LANG, ja_JP.UTF-8"
    ];

    exec-once = [
      "dbus-update-activation-environment --systemd --all"
      "fcitx5 -d --replace"
      "elephant"
      "walker --gapplication-service"
      "waybar"
      "swww init && swww img ~/.config/hypr/wallpaper/abstract-black-background.jpg"
    ];

    input = {
      kb_layout = "us";
      kb_options = "ctrl:nocaps";
      follow_mouse = 1;
      sensitivity = lib.mkDefault 0;
      natural_scroll = true;
      touchpad.natural_scroll = true;
    };

    general = {
      gaps_in = 3;
      gaps_out = 6;
      border_size = 2;
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";
      resize_on_border = false;
      allow_tearing = false;
      layout = "dwindle";
    };

    decoration = {
      rounding = 0;
      shadow = {
        enabled = true;
        range = 2;
        render_power = 3;
        color = "rgba(1a1a1aee)";
      };
      blur = {
        enabled = true;
        size = 2;
        passes = 2;
        special = true;
        brightness = 0.60;
        contrast = 0.75;
      };
    };

    animations = {
      enabled = true;
      bezier = [
        "easeOutQuint, 0.23, 1, 0.32, 1"
        "easeInOutCubic, 0.65, 0.05, 0.36, 1"
        "linear, 0, 0, 1, 1"
        "almostLinear, 0.5, 0.5, 0.75, 1.0"
        "quick, 0.15, 0, 0.1, 1"
      ];
      animation = [
        "global, 1, 10, default"
        "border, 1, 5.39, easeOutQuint"
        "windows, 1, 4.79, easeOutQuint"
        "windowsMove, 1, 6.5, easeOutQuint"
        "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
        "windowsOut, 1, 1.49, linear, popin 87%"
        "fadeIn, 1, 1.73, almostLinear"
        "fadeOut, 1, 1.46, almostLinear"
        "fade, 1, 3.03, quick"
        "layers, 1, 3.81, easeOutQuint"
        "layersIn, 1, 4, easeOutQuint, fade"
        "layersOut, 1, 1.5, linear, fade"
        "fadeLayersIn, 1, 1.79, almostLinear"
        "fadeLayersOut, 1, 1.39, almostLinear"
        "workspaces, 0, 0, ease"
        "specialWorkspace, 1, 4, easeOutQuint, slidevert"
      ];
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
      force_split = 2;
    };

    master.new_status = "master";

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      focus_on_activate = true;
      key_press_enables_dpms = true;
      mouse_move_enables_dpms = true;
    };

    cursor = {
      hide_on_key_press = true;
      warp_on_change_workspace = 1;
    };

    xwayland.force_zero_scaling = true;

    windowrule = [
      "match:class .*, suppress_event maximize"
      "match:class .*, opacity 0.97 0.9"
      "match:class ^(fcitx)$, pseudo on"
      "match:class ^(fcitx)$, no_blur on"
    ];
  };
}
