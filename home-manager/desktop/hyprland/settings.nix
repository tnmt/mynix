{ lib, ... }:
{
  wayland.windowManager.hyprland.settings = {
    "$terminal" = "ghostty";
    "$menu" = "walker";
    "$browser" = "brave";

    env = [
      "XCURSOR_SIZE, 24"
      "HYPRCURSOR_SIZE, 24"
      "GDK_BACKEND, wayland,x11,*"
      "QT_QPA_PLATFORM, wayland;xcb"
      "QT_QPA_PLATFORMTHEME, kvantum"
      "QT_STYLE_OVERRIDE, kvantum"
      "SDL_VIDEODRIVER, wayland,x11"
      "MOZ_ENABLE_WAYLAND, 1"
      "ELECTRON_OZONE_PLATFORM_HINT, wayland"
      "NIXOS_OZONE_WL, 1"
      "XMODIFIERS, @im=fcitx"
      "INPUT_METHOD, fcitx"
      "LANG, ja_JP.UTF-8"
      "SSH_AUTH_SOCK, $HOME/.1password/agent.sock"
      "TERMINAL, ghostty"
    ];

    exec-once = [
      "elephant"
      "walker --gapplication-service"
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
      border_size = 1;
      "col.active_border" = "rgba(7aa2f7ee) rgba(bb9af7ee) 45deg";
      "col.inactive_border" = "rgba(292e4280)";
      resize_on_border = true;
      allow_tearing = true;
      layout = "dwindle";
    };

    decoration = {
      rounding = 8;
      rounding_power = 2;
      inactive_opacity = 0.9;
      shadow = {
        enabled = true;
        range = 1;
        render_power = 3;
        color = "rgba(1a1a1aee)";
      };
      blur = {
        enabled = true;
        size = 8;
        passes = 4;
        special = true;
        noise = 0.034;
        brightness = 1.50;
        contrast = 0.74;
        vibrancy = 1;
        vibrancy_darkness = 0.28;
        xray = true;
      };
    };

    animations = {
      enabled = true;
      bezier = [
        "linear, 0, 0, 1, 1"
        "md3_standard, 0.2, 0, 0, 1"
        "md3_decel, 0.05, 0.7, 0.1, 1"
        "md3_accel, 0.3, 0, 0.8, 0.15"
        "overshot, 0.05, 0.9, 0.1, 1.1"
        "menu_decel, 0.1, 1, 0, 1"
        "menu_accel, 0.38, 0.04, 1, 0.07"
      ];
      animation = [
        "windows, 1, 3, md3_decel, popin 60%"
        "windowsIn, 1, 3, md3_decel, popin 60%"
        "windowsOut, 1, 3, md3_accel, popin 60%"
        "border, 1, 10, default"
        "fade, 1, 3, md3_decel"
        "layersIn, 1, 3, menu_decel, slide"
        "layersOut, 1, 1.6, menu_accel"
        "fadeLayersIn, 1, 2, menu_decel"
        "fadeLayersOut, 1, 4.5, menu_accel"
        "workspaces, 1, 7, menu_decel, slide"
        "specialWorkspace, 1, 3, md3_decel, slidevert"
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
      animate_manual_resizes = true;
      animate_mouse_windowdragging = true;
    };

    ecosystem = {
      no_update_news = true;
      no_donation_nag = true;
    };

    cursor = {
      hide_on_key_press = true;
      inactive_timeout = 3;
      warp_on_change_workspace = 1;
    };

    xwayland.force_zero_scaling = true;

    layerrule = [
      "blur walker"
      "blur waybar"
      "blur notifications"
    ];

    windowrule = [
      "match:class .*, suppress_event maximize"
      "match:class .*, opacity 0.97"
      # Float + center for TUI popup windows
      "match:class ^(tui-float)$, float on"
      "match:class ^(tui-float)$, center on"
      "match:class ^(tui-float)$, size 875 600"
      "match:class ^(fcitx)$, pseudo on"
      "match:class ^(fcitx)$, no_blur on"
    ];
  };
}
