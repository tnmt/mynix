{
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    "$subMod" = "ALT";
    "$term" = "alacritty";
    bind = [
      "$mainMod, Return, exec, $term"
      "$mainMod SHIFT, Q, killactive"
      "$mainMod SHIFT, M, exit"
      "$mainMod, F, fullscreen"
      "$mainMod SHIFT, F, togglefloating"

      # move focus
      "$mainMod, h, movefocus, l"
      "$mainMod, j, movefocus, d"
      "$mainMod, k, movefocus, u"
      "$mainMod, l, movefocus, r"
      "$subMod, Tab, cyclenext"
      "$subMod SHIFT, Tab, cyclenext, prev"

      # switch workspace
      "$mainMod, 1, split-workspace, 1"
      "$mainMod, 2, split-workspace, 2"
      "$mainMod, 3, split-workspace, 3"
      "$mainMod, 4, split-workspace, 4"
      "$mainMod, 5, split-workspace, 5"
      "$mainMod, 6, split-workspace, 6"
      "$mainMod, 7, split-workspace, 7"
      "$mainMod, 8, split-workspace, 8"
      "$mainMod, 9, split-workspace, 9"
      "$mainMod, 0, split-workspace, 10"

      # move window to workspace
      "$mainMod SHIFT, 1, split-movetoworkspacesilent, 1"
      "$mainMod SHIFT, 2, split-movetoworkspacesilent, 2"
      "$mainMod SHIFT, 3, split-movetoworkspacesilent, 3"
      "$mainMod SHIFT, 4, split-movetoworkspacesilent, 4"
      "$mainMod SHIFT, 5, split-movetoworkspacesilent, 5"
      "$mainMod SHIFT, 6, split-movetoworkspacesilent, 6"
      "$mainMod SHIFT, 7, split-movetoworkspacesilent, 7"
      "$mainMod SHIFT, 8, split-movetoworkspacesilent, 8"
      "$mainMod SHIFT, 9, split-movetoworkspacesilent, 9"
      "$mainMod SHIFT, 0, split-movetoworkspacesilent, 10"

      # toggle monitor
      "$mainMod, Tab, exec, hyprctl monitors -j|jq 'map(select(.focused|not).activeWorkspace.id)[0]'|xargs hyprctl dispatch workspace"

      # screenshot
      ", Print, exec, grimblast --notify copy output"
      "$mainMod, Print, exec, grimblast --notify copysave output \"$HOME/Screenshots/$(date +%Y-%m-%dT%H:%M:%S).png\""
      "$mainMod SHIFT, s, exec, grimblast --notify copysave area \"$HOME/Screenshots/$(date +%Y-%m-%dT%H:%M:%S).png\""

      # launcher
      "$mainMod, s, exec, wofi --show drun --width 512px"
      "$mainMod, period, exec, wofi-emoji"

      # color picker
      "$mainMod SHIFT, c, exec, hyprpicker --autocopy"

      # screen lock
      "$mainMod, l, exec, swaylock"

      # system
      "$mainMod, x, exec, systemctl suspend"
    ];
    bindm = [
      # move/resize window
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
    bindl = [
      # media control
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"

      # volume control: mute
      ", XF86AudioMute, exec, pamixer -t"
    ];
    bindle = [
      # volume control
      ", XF86AudioRaiseVolume, exec, pamixer -i 10"
      ", XF86AudioLowerVolume, exec, pamixer -d 10"

      # brightness control
      ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
      ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
    ];
  };
}
