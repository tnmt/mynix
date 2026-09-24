{
  lib,
  terminal,
  ...
}:
let
  # Hyprland 0.55+ Lua binds. Helpers keep the `description` flag from repeating.
  # keys: a Lua key string ("SUPER + W"); disp: a raw Lua dispatcher expression.
  b =
    keys: desc: disp:
    ''hl.bind("${keys}", ${disp}, { description = "${desc}" })'';
  # locked: also fires while an input inhibitor (lockscreen) is active.
  bl =
    keys: desc: disp:
    ''hl.bind("${keys}", ${disp}, { description = "${desc}", locked = true })'';
  # locked + repeating (held keys repeat).
  bel =
    keys: desc: disp:
    ''hl.bind("${keys}", ${disp}, { description = "${desc}", locked = true, repeating = true })'';
  # mouse bind (interactive drag/resize).
  bm =
    keys: desc: disp:
    ''hl.bind("${keys}", ${disp}, { description = "${desc}", mouse = true })'';

  binds = [
    (b "SUPER + W" "Close window" "hl.dsp.window.close()")

    # Control tiling
    (b "SUPER + J" "Toggle window split" ''hl.dsp.layout("togglesplit")'')
    (b "SUPER + P" "Pseudo window" "hl.dsp.window.pseudo()")
    (b "SUPER + T" "Toggle window floating/tiling" "hl.dsp.window.float()")
    (b "SUPER + O" "Pop out window (float + pin)" ''hl.dsp.exec_cmd("window-pop")'')
    (b "SUPER + L" "Toggle workspace layout" ''hl.dsp.exec_cmd("toggle-workspace-layout")'')
    (b "SUPER + F" "Full screen" ''hl.dsp.window.fullscreen({ mode = "fullscreen" })'')
    (b "SUPER + CTRL + F" "Tiled full screen"
      ''hl.dsp.window.fullscreen_state({ internal = 0, client = 2, action = "toggle" })''
    )
    (b "SUPER + ALT + F" "Full width" ''hl.dsp.window.fullscreen({ mode = "maximized" })'')

    # Move focus with SUPER + arrow keys
    (b "SUPER + LEFT" "Move window focus left" ''hl.dsp.focus({ direction = "l" })'')
    (b "SUPER + RIGHT" "Move window focus right" ''hl.dsp.focus({ direction = "r" })'')
    (b "SUPER + UP" "Move window focus up" ''hl.dsp.focus({ direction = "u" })'')
    (b "SUPER + DOWN" "Move window focus down" ''hl.dsp.focus({ direction = "d" })'')

    # Switch workspaces with SUPER + [1-9; 0]
    (b "SUPER + code:10" "Switch to workspace 1" "hl.dsp.focus({ workspace = 1 })")
    (b "SUPER + code:11" "Switch to workspace 2" "hl.dsp.focus({ workspace = 2 })")
    (b "SUPER + code:12" "Switch to workspace 3" "hl.dsp.focus({ workspace = 3 })")
    (b "SUPER + code:13" "Switch to workspace 4" "hl.dsp.focus({ workspace = 4 })")
    (b "SUPER + code:14" "Switch to workspace 5" "hl.dsp.focus({ workspace = 5 })")
    (b "SUPER + code:15" "Switch to workspace 6" "hl.dsp.focus({ workspace = 6 })")
    (b "SUPER + code:16" "Switch to workspace 7" "hl.dsp.focus({ workspace = 7 })")
    (b "SUPER + code:17" "Switch to workspace 8" "hl.dsp.focus({ workspace = 8 })")
    (b "SUPER + code:18" "Switch to workspace 9" "hl.dsp.focus({ workspace = 9 })")
    (b "SUPER + code:19" "Switch to workspace 10" "hl.dsp.focus({ workspace = 10 })")

    # Move active window to a workspace with SUPER + SHIFT + [1-9; 0]
    (b "SUPER + SHIFT + code:10" "Move window to workspace 1"
      "hl.dsp.window.move({ workspace = 1, follow = true })"
    )
    (b "SUPER + SHIFT + code:11" "Move window to workspace 2"
      "hl.dsp.window.move({ workspace = 2, follow = true })"
    )
    (b "SUPER + SHIFT + code:12" "Move window to workspace 3"
      "hl.dsp.window.move({ workspace = 3, follow = true })"
    )
    (b "SUPER + SHIFT + code:13" "Move window to workspace 4"
      "hl.dsp.window.move({ workspace = 4, follow = true })"
    )
    (b "SUPER + SHIFT + code:14" "Move window to workspace 5"
      "hl.dsp.window.move({ workspace = 5, follow = true })"
    )
    (b "SUPER + SHIFT + code:15" "Move window to workspace 6"
      "hl.dsp.window.move({ workspace = 6, follow = true })"
    )
    (b "SUPER + SHIFT + code:16" "Move window to workspace 7"
      "hl.dsp.window.move({ workspace = 7, follow = true })"
    )
    (b "SUPER + SHIFT + code:17" "Move window to workspace 8"
      "hl.dsp.window.move({ workspace = 8, follow = true })"
    )
    (b "SUPER + SHIFT + code:18" "Move window to workspace 9"
      "hl.dsp.window.move({ workspace = 9, follow = true })"
    )
    (b "SUPER + SHIFT + code:19" "Move window to workspace 10"
      "hl.dsp.window.move({ workspace = 10, follow = true })"
    )

    # Move active window silently to a workspace
    (b "SUPER + SHIFT + ALT + code:10" "Move window silently to workspace 1"
      "hl.dsp.window.move({ workspace = 1, follow = false })"
    )
    (b "SUPER + SHIFT + ALT + code:11" "Move window silently to workspace 2"
      "hl.dsp.window.move({ workspace = 2, follow = false })"
    )
    (b "SUPER + SHIFT + ALT + code:12" "Move window silently to workspace 3"
      "hl.dsp.window.move({ workspace = 3, follow = false })"
    )
    (b "SUPER + SHIFT + ALT + code:13" "Move window silently to workspace 4"
      "hl.dsp.window.move({ workspace = 4, follow = false })"
    )
    (b "SUPER + SHIFT + ALT + code:14" "Move window silently to workspace 5"
      "hl.dsp.window.move({ workspace = 5, follow = false })"
    )
    (b "SUPER + SHIFT + ALT + code:15" "Move window silently to workspace 6"
      "hl.dsp.window.move({ workspace = 6, follow = false })"
    )
    (b "SUPER + SHIFT + ALT + code:16" "Move window silently to workspace 7"
      "hl.dsp.window.move({ workspace = 7, follow = false })"
    )
    (b "SUPER + SHIFT + ALT + code:17" "Move window silently to workspace 8"
      "hl.dsp.window.move({ workspace = 8, follow = false })"
    )
    (b "SUPER + SHIFT + ALT + code:18" "Move window silently to workspace 9"
      "hl.dsp.window.move({ workspace = 9, follow = false })"
    )
    (b "SUPER + SHIFT + ALT + code:19" "Move window silently to workspace 10"
      "hl.dsp.window.move({ workspace = 10, follow = false })"
    )

    # Scratchpad
    (b "SUPER + S" "Toggle scratchpad" ''hl.dsp.workspace.toggle_special("scratchpad")'')
    (b "SUPER + ALT + S" "Move window to scratchpad"
      ''hl.dsp.window.move({ workspace = "special:scratchpad" })''
    )

    # TAB between workspaces
    (b "SUPER + TAB" "Next workspace" ''hl.dsp.focus({ workspace = "e+1" })'')
    (b "SUPER + SHIFT + TAB" "Previous workspace" ''hl.dsp.focus({ workspace = "e-1" })'')
    (b "SUPER + CTRL + TAB" "Former workspace" ''hl.dsp.focus({ workspace = "previous" })'')

    # Cycle keyboard focus across monitors
    (b "CTRL + ALT + TAB" "Focus next monitor" ''hl.dsp.exec_cmd("hyprctl dispatch focusmonitor +1")'')
    (b "CTRL + ALT + SHIFT + TAB" "Focus previous monitor"
      ''hl.dsp.exec_cmd("hyprctl dispatch focusmonitor -1")''
    )

    # Move workspaces to other monitors
    (b "SUPER + SHIFT + ALT + LEFT" "Move workspace to left monitor"
      ''hl.dsp.workspace.move({ monitor = "l" })''
    )
    (b "SUPER + SHIFT + ALT + RIGHT" "Move workspace to right monitor"
      ''hl.dsp.workspace.move({ monitor = "r" })''
    )
    (b "SUPER + SHIFT + ALT + UP" "Move workspace to up monitor"
      ''hl.dsp.workspace.move({ monitor = "u" })''
    )
    (b "SUPER + SHIFT + ALT + DOWN" "Move workspace to down monitor"
      ''hl.dsp.workspace.move({ monitor = "d" })''
    )

    # Swap active window
    (b "SUPER + SHIFT + LEFT" "Swap window to the left" ''hl.dsp.window.swap({ direction = "l" })'')
    (b "SUPER + SHIFT + RIGHT" "Swap window to the right" ''hl.dsp.window.swap({ direction = "r" })'')
    (b "SUPER + SHIFT + UP" "Swap window up" ''hl.dsp.window.swap({ direction = "u" })'')
    (b "SUPER + SHIFT + DOWN" "Swap window down" ''hl.dsp.window.swap({ direction = "d" })'')

    # Cycle through windows
    (b "ALT + TAB" "Cycle to next window" "hl.dsp.window.cycle_next()")
    (b "ALT + SHIFT + TAB" "Cycle to prev window" "hl.dsp.window.cycle_next({ next = false })")
    (b "ALT + TAB" "Reveal active window on top" ''hl.dsp.window.alter_zorder({ mode = "top" })'')
    (b "ALT + SHIFT + TAB" "Reveal active window on top"
      ''hl.dsp.window.alter_zorder({ mode = "top" })''
    )

    # Resize active window
    (b "SUPER + code:20" "Expand window left"
      "hl.dsp.window.resize({ x = -100, y = 0, relative = true })"
    )
    (b "SUPER + code:21" "Shrink window left"
      "hl.dsp.window.resize({ x = 100, y = 0, relative = true })"
    )
    (b "SUPER + SHIFT + code:20" "Shrink window up"
      "hl.dsp.window.resize({ x = 0, y = -100, relative = true })"
    )
    (b "SUPER + SHIFT + code:21" "Expand window down"
      "hl.dsp.window.resize({ x = 0, y = 100, relative = true })"
    )

    # Scroll through workspaces
    (b "SUPER + mouse_down" "Scroll active workspace forward" ''hl.dsp.focus({ workspace = "e+1" })'')
    (b "SUPER + mouse_up" "Scroll active workspace backward" ''hl.dsp.focus({ workspace = "e-1" })'')

    # Toggle groups
    (b "SUPER + G" "Toggle window grouping" "hl.dsp.group.toggle()")
    (b "SUPER + ALT + G" "Move active window out of group"
      "hl.dsp.window.move({ out_of_group = true })"
    )

    # Join groups
    (b "SUPER + ALT + LEFT" "Move window to group on left" ''hl.dsp.window.move({ into_group = "l" })'')
    (b "SUPER + ALT + RIGHT" "Move window to group on right"
      ''hl.dsp.window.move({ into_group = "r" })''
    )
    (b "SUPER + ALT + UP" "Move window to group on top" ''hl.dsp.window.move({ into_group = "u" })'')
    (b "SUPER + ALT + DOWN" "Move window to group on bottom"
      ''hl.dsp.window.move({ into_group = "d" })''
    )

    # Navigate grouped windows
    (b "SUPER + ALT + TAB" "Next window in group" "hl.dsp.group.next()")
    (b "SUPER + ALT + SHIFT + TAB" "Previous window in group" "hl.dsp.group.prev()")
    (b "SUPER + CTRL + LEFT" "Move grouped window focus left" "hl.dsp.group.prev()")
    (b "SUPER + CTRL + RIGHT" "Move grouped window focus right" "hl.dsp.group.next()")
    (b "SUPER + ALT + mouse_down" "Next window in group" "hl.dsp.group.next()")
    (b "SUPER + ALT + mouse_up" "Previous window in group" "hl.dsp.group.prev()")

    # Activate window in group by number
    (b "SUPER + ALT + code:10" "Switch to group window 1" "hl.dsp.group.active({ index = 1 })")
    (b "SUPER + ALT + code:11" "Switch to group window 2" "hl.dsp.group.active({ index = 2 })")
    (b "SUPER + ALT + code:12" "Switch to group window 3" "hl.dsp.group.active({ index = 3 })")
    (b "SUPER + ALT + code:13" "Switch to group window 4" "hl.dsp.group.active({ index = 4 })")
    (b "SUPER + ALT + code:14" "Switch to group window 5" "hl.dsp.group.active({ index = 5 })")

    # Copy / Paste
    (b "SUPER + C" "Universal copy" ''hl.dsp.send_shortcut({ mods = "CTRL", key = "Insert" })'')
    (b "SUPER + V" "Universal paste" ''hl.dsp.send_shortcut({ mods = "SHIFT", key = "Insert" })'')
    (b "SUPER + X" "Universal cut" ''hl.dsp.send_shortcut({ mods = "CTRL", key = "X" })'')
    (b "SUPER + SHIFT + C" "Clipboard manager"
      ''hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard")''
    )

    # Menus
    (b "SUPER + SPACE" "Launch apps" ''hl.dsp.exec_cmd("noctalia msg panel-toggle launcher")'')
    (b "SUPER + CTRL + E" "Emoji picker" ''hl.dsp.exec_cmd("noctalia msg panel-toggle launcher /emo")'')
    (b "SUPER + K" "Show key bindings" ''hl.dsp.exec_cmd("show-keybindings")'')

    # Application bindings
    (b "SUPER + RETURN" "Terminal in current directory"
      ''hl.dsp.exec_cmd([[${terminal.default} --working-directory="$(terminal-cwd)"]])''
    )
    (b "SUPER + ALT + RETURN" "Tmux"
      ''hl.dsp.exec_cmd("${terminal.default} bash -c 'tmux attach || tmux new -s Work'")''
    )
    (b "SUPER + SHIFT + RETURN" "Browser" ''hl.dsp.exec_cmd("launch-browser")'')
    (b "SUPER + SHIFT + B" "Browser" ''hl.dsp.exec_cmd("launch-browser")'')
    (b "SUPER + SHIFT + ALT + B" "Browser (private)" ''hl.dsp.exec_cmd("launch-browser --private")'')
    (b "SUPER + SHIFT + F" "File manager in current directory"
      ''hl.dsp.exec_cmd([[thunar "$(terminal-cwd)"]])''
    )
    (b "SUPER + SHIFT + SLASH" "Passwords" "hl.dsp.exec_cmd([[launch-or-focus 1password 1password]])")

    (b "SUPER + BACKSPACE" "Toggle window transparency"
      ''hl.dsp.exec_cmd([[hyprctl dispatch setprop "address:$(hyprctl activewindow -j | jq -r '.address')" opaque toggle]])''
    )

    # Zoom
    (b "SUPER + CTRL + Z" "Zoom in"
      "hl.dsp.exec_cmd([[hyprctl keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float + 1')]])"
    )
    (b "SUPER + CTRL + ALT + Z" "Reset zoom"
      ''hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor 1")''
    )

    # Screenshot (Mac-style 3/4/5, but CTRL instead of SHIFT since SUPER+SHIFT+<digit>
    # is already "move window to workspace N"). Output policy (save/clipboard) lives
    # in Noctalia's [shell.screenshot] settings, not per-keybind.
    (b "SUPER + CTRL + code:12" "Screenshot fullscreen"
      ''hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen")''
    )
    (b "SUPER + CTRL + code:13" "Screenshot region"
      ''hl.dsp.exec_cmd("noctalia msg screenshot-region")''
    )
    (b "SUPER + CTRL + code:14" "Screenshot freeze & annotate"
      ''hl.dsp.exec_cmd("noctalia msg screenshot-annotate")''
    )
    (b "SUPER + CTRL + SHIFT + code:12" "Screenshot fullscreen (pick display)"
      ''hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen pick")''
    )
    (b "SUPER + PRINT" "Pick color" ''hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a")'')
    (b "SUPER + CTRL + PRINT" "Extract text from selection" ''hl.dsp.exec_cmd("ocr-selection")'')
    (b "ALT + PRINT" "Toggle screen recording" ''hl.dsp.exec_cmd("screen-record")'')
    (b "SUPER + ALT + COMMA" "Open latest capture" ''hl.dsp.exec_cmd("open-latest-capture")'')

    # Settings / Controls
    (b "SUPER + ALT + SPACE" "Control center"
      ''hl.dsp.exec_cmd("noctalia msg panel-toggle control-center")''
    )
    (b "SUPER + SHIFT + A" "Switch audio output" ''hl.dsp.exec_cmd("switch-audio")'')
    (b "SUPER + SHIFT + I" "Switch audio input" ''hl.dsp.exec_cmd("switch-audio-input")'')
    (b "SUPER + CTRL + N" "Toggle night light" ''hl.dsp.exec_cmd("toggle-nightlight")'')
    (b "SUPER + CTRL + I" "Toggle idle inhibition" ''hl.dsp.exec_cmd("noctalia msg caffeine-toggle")'')
    (b "SUPER + CTRL + P" "Toggle presentation mode" ''hl.dsp.exec_cmd("toggle-presentation-mode")'')

    # Voice input
    (b "SUPER + M" "Toggle voice input" ''hl.dsp.exec_cmd("voice-input")'')
    (b "SUPER + SHIFT + M" "Toggle voice input (LLM refine)"
      ''hl.dsp.exec_cmd("voice-input --refine")''
    )

    # System
    (b "SUPER + ESCAPE" "System menu" ''hl.dsp.exec_cmd("noctalia msg panel-toggle session")'')
    (b "SUPER + CTRL + L" "Lock system" ''hl.dsp.exec_cmd("noctalia msg session lock")'')

    # Mouse binds
    (bm "SUPER + mouse:272" "Move window" "hl.dsp.window.drag()")
    (bm "SUPER + mouse:273" "Resize window" "hl.dsp.window.resize()")

    # Media keys (locked so they work on the lockscreen)
    (bl "XF86AudioPlay" "Play" ''hl.dsp.exec_cmd("playerctl play-pause")'')
    (bl "XF86AudioPrev" "Previous track" ''hl.dsp.exec_cmd("playerctl previous")'')
    (bl "XF86AudioNext" "Next track" ''hl.dsp.exec_cmd("playerctl next")'')
    (bl "XF86AudioMute" "Mute" ''hl.dsp.exec_cmd("noctalia msg volume-mute")'')
    (bl "XF86AudioMicMute" "Mute microphone" ''hl.dsp.exec_cmd("noctalia msg mic-mute")'')

    # Volume / brightness (locked + repeating)
    (bel "XF86AudioRaiseVolume" "Volume up" ''hl.dsp.exec_cmd("noctalia msg volume-up")'')
    (bel "XF86AudioLowerVolume" "Volume down" ''hl.dsp.exec_cmd("noctalia msg volume-down")'')
    (bel "ALT + XF86AudioRaiseVolume" "Volume up 1%" ''hl.dsp.exec_cmd("noctalia msg volume-up 1")'')
    (bel "ALT + XF86AudioLowerVolume" "Volume down 1%"
      ''hl.dsp.exec_cmd("noctalia msg volume-down 1")''
    )
    (bel "XF86MonBrightnessUp" "Brightness up" ''hl.dsp.exec_cmd("brightness-adjust up")'')
    (bel "XF86MonBrightnessDown" "Brightness down" ''hl.dsp.exec_cmd("brightness-adjust down")'')
    (bel "ALT + XF86MonBrightnessUp" "Brightness up 1%" ''hl.dsp.exec_cmd("brightness-adjust up 1")'')
    (bel "ALT + XF86MonBrightnessDown" "Brightness down 1%"
      ''hl.dsp.exec_cmd("brightness-adjust down 1")''
    )
  ];
in
{
  wayland.windowManager.hyprland.extraConfig = lib.mkOrder 900 (
    "-- Keybinds\n" + lib.concatStringsSep "\n" binds + "\n"
  );
}
