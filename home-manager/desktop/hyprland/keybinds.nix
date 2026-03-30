{
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    bind = [
      # Window management
      "$mainMod, W, killactive"
      "$mainMod, T, togglefloating"
      "$mainMod, F, fullscreen, 0"
      "$mainMod CTRL, F, fullscreenstate, 0 2"
      "$mainMod ALT, F, fullscreen, 1"
      "$mainMod, J, layoutmsg, togglesplit"
      "$mainMod, P, pseudo"

      # Focus
      "$mainMod, LEFT, movefocus, l"
      "$mainMod, RIGHT, movefocus, r"
      "$mainMod, UP, movefocus, u"
      "$mainMod, DOWN, movefocus, d"
      "ALT, Tab, cyclenext"
      "ALT SHIFT, Tab, cyclenext, prev"

      # Workspaces
      "$mainMod, code:10, workspace, 1"
      "$mainMod, code:11, workspace, 2"
      "$mainMod, code:12, workspace, 3"
      "$mainMod, code:13, workspace, 4"
      "$mainMod, code:14, workspace, 5"
      "$mainMod, code:15, workspace, 6"
      "$mainMod, code:16, workspace, 7"
      "$mainMod, code:17, workspace, 8"
      "$mainMod, code:18, workspace, 9"
      "$mainMod, code:19, workspace, 10"

      # Move to workspace
      "$mainMod SHIFT, code:10, movetoworkspace, 1"
      "$mainMod SHIFT, code:11, movetoworkspace, 2"
      "$mainMod SHIFT, code:12, movetoworkspace, 3"
      "$mainMod SHIFT, code:13, movetoworkspace, 4"
      "$mainMod SHIFT, code:14, movetoworkspace, 5"
      "$mainMod SHIFT, code:15, movetoworkspace, 6"
      "$mainMod SHIFT, code:16, movetoworkspace, 7"
      "$mainMod SHIFT, code:17, movetoworkspace, 8"
      "$mainMod SHIFT, code:18, movetoworkspace, 9"
      "$mainMod SHIFT, code:19, movetoworkspace, 10"

      # Scratchpad
      "$mainMod, S, togglespecialworkspace, scratchpad"
      "$mainMod ALT, S, movetoworkspacesilent, special:scratchpad"

      # Workspace navigation
      "$mainMod, TAB, workspace, e+1"
      "$mainMod SHIFT, TAB, workspace, e-1"
      "$mainMod CTRL, TAB, workspace, previous"

      # Swap windows
      "$mainMod SHIFT, LEFT, swapwindow, l"
      "$mainMod SHIFT, RIGHT, swapwindow, r"
      "$mainMod SHIFT, UP, swapwindow, u"
      "$mainMod SHIFT, DOWN, swapwindow, d"

      # Move workspaces between monitors
      "$mainMod SHIFT ALT, LEFT, movecurrentworkspacetomonitor, l"
      "$mainMod SHIFT ALT, RIGHT, movecurrentworkspacetomonitor, r"

      # Resize
      "$mainMod, code:20, resizeactive, -100 0"
      "$mainMod, code:21, resizeactive, 100 0"
      "$mainMod SHIFT, code:20, resizeactive, 0 -100"
      "$mainMod SHIFT, code:21, resizeactive, 0 100"

      # Groups
      "$mainMod, G, togglegroup"
      "$mainMod ALT, G, moveoutofgroup"
      "$mainMod ALT, LEFT, moveintogroup, l"
      "$mainMod ALT, RIGHT, moveintogroup, r"
      "$mainMod ALT, TAB, changegroupactive, f"

      # Copy/Paste
      "$mainMod, C, sendshortcut, CTRL, Insert,"
      "$mainMod, V, sendshortcut, SHIFT, Insert,"
      "$mainMod CTRL, V, exec, walker -m clipboard"

      # Applications
      "$mainMod, RETURN, exec, $terminal"
      "$mainMod ALT, RETURN, exec, $terminal bash -c 'tmux attach || tmux new -s Work'"
      "$mainMod SHIFT, RETURN, exec, $browser"
      "$mainMod SHIFT, SLASH, exec, 1password"

      # Launcher
      "$mainMod, SPACE, exec, walker"
      "$mainMod CTRL, E, exec, walker -m symbols"

      # Window transparency toggle
      "$mainMod, BACKSPACE, exec, hyprctl dispatch setprop address:$(hyprctl activewindow -j | jq -r '.address') opaque toggle"

      # Screenshot
      ", PRINT, exec, grim -g \"$(slurp)\" - | wl-copy"

      # System
      "$mainMod, ESCAPE, exec, wlogout"
    ];

    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    bindl = [
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioMute, exec, pamixer -t"
    ];

    bindle = [
      ", XF86AudioRaiseVolume, exec, pamixer -i 10"
      ", XF86AudioLowerVolume, exec, pamixer -d 10"
      ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
      ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
    ];
  };
}
