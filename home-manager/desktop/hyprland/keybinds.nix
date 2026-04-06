{
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    bindd = [
      # Close windows
      "$mainMod, W, Close window, killactive,"

      # Control tiling
      "$mainMod, J, Toggle window split, layoutmsg, togglesplit"
      "$mainMod, P, Pseudo window, pseudo,"
      "$mainMod, T, Toggle window floating/tiling, togglefloating,"
      "$mainMod, F, Full screen, fullscreen, 0"
      "$mainMod CTRL, F, Tiled full screen, fullscreenstate, 0 2"
      "$mainMod ALT, F, Full width, fullscreen, 1"

      # Move focus with SUPER + arrow keys
      "$mainMod, LEFT, Move window focus left, movefocus, l"
      "$mainMod, RIGHT, Move window focus right, movefocus, r"
      "$mainMod, UP, Move window focus up, movefocus, u"
      "$mainMod, DOWN, Move window focus down, movefocus, d"

      # Switch workspaces with SUPER + [1-9; 0]
      "$mainMod, code:10, Switch to workspace 1, workspace,1"
      "$mainMod, code:11, Switch to workspace 2, workspace,2"
      "$mainMod, code:12, Switch to workspace 3, workspace,3"
      "$mainMod, code:13, Switch to workspace 4, workspace,4"
      "$mainMod, code:14, Switch to workspace 5, workspace,5"
      "$mainMod, code:15, Switch to workspace 6, workspace,6"
      "$mainMod, code:16, Switch to workspace 7, workspace,7"
      "$mainMod, code:17, Switch to workspace 8, workspace,8"
      "$mainMod, code:18, Switch to workspace 9, workspace,9"
      "$mainMod, code:19, Switch to workspace 10, workspace,10"

      # Move active window to a workspace with SUPER + SHIFT + [1-9; 0]
      "$mainMod SHIFT, code:10, Move window to workspace 1, movetoworkspace,1"
      "$mainMod SHIFT, code:11, Move window to workspace 2, movetoworkspace,2"
      "$mainMod SHIFT, code:12, Move window to workspace 3, movetoworkspace,3"
      "$mainMod SHIFT, code:13, Move window to workspace 4, movetoworkspace,4"
      "$mainMod SHIFT, code:14, Move window to workspace 5, movetoworkspace,5"
      "$mainMod SHIFT, code:15, Move window to workspace 6, movetoworkspace,6"
      "$mainMod SHIFT, code:16, Move window to workspace 7, movetoworkspace,7"
      "$mainMod SHIFT, code:17, Move window to workspace 8, movetoworkspace,8"
      "$mainMod SHIFT, code:18, Move window to workspace 9, movetoworkspace,9"
      "$mainMod SHIFT, code:19, Move window to workspace 10, movetoworkspace,10"

      # Move active window silently to a workspace
      "$mainMod SHIFT ALT, code:10, Move window silently to workspace 1, movetoworkspacesilent,1"
      "$mainMod SHIFT ALT, code:11, Move window silently to workspace 2, movetoworkspacesilent,2"
      "$mainMod SHIFT ALT, code:12, Move window silently to workspace 3, movetoworkspacesilent,3"
      "$mainMod SHIFT ALT, code:13, Move window silently to workspace 4, movetoworkspacesilent,4"
      "$mainMod SHIFT ALT, code:14, Move window silently to workspace 5, movetoworkspacesilent,5"
      "$mainMod SHIFT ALT, code:15, Move window silently to workspace 6, movetoworkspacesilent,6"
      "$mainMod SHIFT ALT, code:16, Move window silently to workspace 7, movetoworkspacesilent,7"
      "$mainMod SHIFT ALT, code:17, Move window silently to workspace 8, movetoworkspacesilent,8"
      "$mainMod SHIFT ALT, code:18, Move window silently to workspace 9, movetoworkspacesilent,9"
      "$mainMod SHIFT ALT, code:19, Move window silently to workspace 10, movetoworkspacesilent,10"

      # Scratchpad
      "$mainMod, S, Toggle scratchpad, togglespecialworkspace, scratchpad"
      "$mainMod ALT, S, Move window to scratchpad, movetoworkspacesilent, special:scratchpad"

      # TAB between workspaces
      "$mainMod, TAB, Next workspace, workspace,e+1"
      "$mainMod SHIFT, TAB, Previous workspace, workspace,e-1"
      "$mainMod CTRL, TAB, Former workspace, workspace,previous"

      # Move workspaces to other monitors
      "$mainMod SHIFT ALT, LEFT, Move workspace to left monitor, movecurrentworkspacetomonitor, l"
      "$mainMod SHIFT ALT, RIGHT, Move workspace to right monitor, movecurrentworkspacetomonitor, r"
      "$mainMod SHIFT ALT, UP, Move workspace to up monitor, movecurrentworkspacetomonitor, u"
      "$mainMod SHIFT ALT, DOWN, Move workspace to down monitor, movecurrentworkspacetomonitor, d"

      # Swap active window
      "$mainMod SHIFT, LEFT, Swap window to the left, swapwindow, l"
      "$mainMod SHIFT, RIGHT, Swap window to the right, swapwindow, r"
      "$mainMod SHIFT, UP, Swap window up, swapwindow, u"
      "$mainMod SHIFT, DOWN, Swap window down, swapwindow, d"

      # Cycle through windows
      "ALT, TAB, Cycle to next window, cyclenext"
      "ALT SHIFT, TAB, Cycle to prev window, cyclenext, prev"
      "ALT, TAB, Reveal active window on top, bringactivetotop"
      "ALT SHIFT, TAB, Reveal active window on top, bringactivetotop"

      # Resize active window
      "$mainMod, code:20, Expand window left, resizeactive, -100 0"
      "$mainMod, code:21, Shrink window left, resizeactive, 100 0"
      "$mainMod SHIFT, code:20, Shrink window up, resizeactive, 0 -100"
      "$mainMod SHIFT, code:21, Expand window down, resizeactive, 0 100"

      # Scroll through workspaces
      "$mainMod, mouse_down, Scroll active workspace forward, workspace,e+1"
      "$mainMod, mouse_up, Scroll active workspace backward, workspace,e-1"

      # Toggle groups
      "$mainMod, G, Toggle window grouping, togglegroup"
      "$mainMod ALT, G, Move active window out of group, moveoutofgroup"

      # Join groups
      "$mainMod ALT, LEFT, Move window to group on left, moveintogroup, l"
      "$mainMod ALT, RIGHT, Move window to group on right, moveintogroup, r"
      "$mainMod ALT, UP, Move window to group on top, moveintogroup, u"
      "$mainMod ALT, DOWN, Move window to group on bottom, moveintogroup, d"

      # Navigate grouped windows
      "$mainMod ALT, TAB, Next window in group, changegroupactive, f"
      "$mainMod ALT SHIFT, TAB, Previous window in group, changegroupactive, b"
      "$mainMod CTRL, LEFT, Move grouped window focus left, changegroupactive, b"
      "$mainMod CTRL, RIGHT, Move grouped window focus right, changegroupactive, f"
      "$mainMod ALT, mouse_down, Next window in group, changegroupactive, f"
      "$mainMod ALT, mouse_up, Previous window in group, changegroupactive, b"

      # Activate window in group by number
      "$mainMod ALT, code:10, Switch to group window 1, changegroupactive, 1"
      "$mainMod ALT, code:11, Switch to group window 2, changegroupactive, 2"
      "$mainMod ALT, code:12, Switch to group window 3, changegroupactive, 3"
      "$mainMod ALT, code:13, Switch to group window 4, changegroupactive, 4"
      "$mainMod ALT, code:14, Switch to group window 5, changegroupactive, 5"

      # Copy / Paste
      "$mainMod, C, Universal copy, sendshortcut, CTRL, Insert,"
      "$mainMod, V, Universal paste, sendshortcut, SHIFT, Insert,"
      "$mainMod, X, Universal cut, sendshortcut, CTRL, X,"
      "$mainMod CTRL, V, Clipboard manager, exec, walker -m clipboard"

      # Menus
      "$mainMod, SPACE, Launch apps, exec, launch-walker"
      "$mainMod CTRL, E, Emoji picker, exec, launch-walker -m symbols"

      # Application bindings
      "$mainMod, RETURN, Terminal, exec, $terminal"
      "$mainMod ALT, RETURN, Tmux, exec, $terminal bash -c 'tmux attach || tmux new -s Work' "
      "$mainMod SHIFT, RETURN, Browser, exec, launch-browser"
      "$mainMod SHIFT, B, Browser, exec, launch-browser"
      "$mainMod SHIFT ALT, B, Browser (private), exec, launch-browser --private"
      "$mainMod SHIFT, SLASH, Passwords, exec, 1password"

      # Window transparency toggle
      ''$mainMod, BACKSPACE, Toggle window transparency, exec, hyprctl dispatch setprop "address:$(hyprctl activewindow -j | jq -r '.address')" opaque toggle''

      # Zoom
      "$mainMod CTRL, Z, Zoom in, exec, hyprctl keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float + 1')"
      "$mainMod CTRL ALT, Z, Reset zoom, exec, hyprctl keyword cursor:zoom_factor 1"

      # Screenshot (P = Print)
      ''$mainMod, P, Screenshot region to clipboard, exec, grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot" "Copied to clipboard" -t 2000''
      ''$mainMod SHIFT, P, Screenshot fullscreen to clipboard, exec, grim - | wl-copy && notify-send "Screenshot" "Copied to clipboard" -t 2000''
      ''$mainMod ALT, P, Screenshot region to file, exec, mkdir -p ~/Pictures/Screenshots && grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png && notify-send "Screenshot" "Saved to ~/Pictures/Screenshots" -t 2000''
      ''$mainMod ALT SHIFT, P, Screenshot fullscreen to file, exec, mkdir -p ~/Pictures/Screenshots && grim ~/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png && notify-send "Screenshot" "Saved to ~/Pictures/Screenshots" -t 2000''

      # Settings / Controls
      "$mainMod ALT, SPACE, Settings menu, exec, launch-settings"
      "$mainMod SHIFT, A, Switch audio output, exec, switch-audio"

      # System
      "$mainMod, ESCAPE, System menu, exec, wlogout"
    ];

    bindmd = [
      "$mainMod, mouse:272, Move window, movewindow"
      "$mainMod, mouse:273, Resize window, resizewindow"
    ];

    bindld = [
      ", XF86AudioPlay, Play, exec, playerctl play-pause"
      ", XF86AudioPrev, Previous track, exec, playerctl previous"
      ", XF86AudioNext, Next track, exec, playerctl next"
      ", XF86AudioMute, Mute, exec, pamixer -t"
    ];

    bindeld = [
      ", XF86AudioRaiseVolume, Volume up, exec, pamixer -i 10"
      ", XF86AudioLowerVolume, Volume down, exec, pamixer -d 10"
      ", XF86MonBrightnessUp, Brightness up, exec, brightnessctl set +10%"
      ", XF86MonBrightnessDown, Brightness down, exec, brightnessctl set 10%-"
    ];
  };
}
