{ pkgs, ... }:
let
  tomlFormat = pkgs.formats.toml { };
in
{
  xdg.configFile."aerospace/aerospace.toml".source = tomlFormat.generate "aerospace.toml" {
    # General
    start-at-login = true;
    after-login-command = [ ];
    after-startup-command = [ ];
    enable-normalization-flatten-containers = true;
    enable-normalization-opposite-orientation-for-nested-containers = true;
    accordion-padding = 30;
    default-root-container-layout = "tiles";
    default-root-container-orientation = "auto";
    on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

    # Workspace-to-monitor assignment (1=laptop, 2-10=external)
    # main=DELL(external), secondary=Built-in(laptop)
    workspace-to-monitor-force-assignment = {
      "1" = [
        "secondary"
        "main"
      ];
      "2" = [
        "main"
        "secondary"
      ];
      "3" = [
        "main"
        "secondary"
      ];
      "4" = [
        "main"
        "secondary"
      ];
      "5" = [
        "main"
        "secondary"
      ];
      "6" = [
        "main"
        "secondary"
      ];
      "7" = [
        "main"
        "secondary"
      ];
      "8" = [
        "main"
        "secondary"
      ];
      "9" = [
        "main"
        "secondary"
      ];
      "10" = [
        "main"
        "secondary"
      ];
    };

    # Gaps (matching Hyprland: gaps_in=3, gaps_out=6)
    gaps = {
      inner.horizontal = 6;
      inner.vertical = 6;
      outer.left = 6;
      outer.right = 6;
      outer.top = 6;
      outer.bottom = 6;
    };

    mode.main.binding = {
      # ── Window management ──
      "alt-w" = "close";
      "alt-f" = "fullscreen";
      "alt-t" = "layout floating tiling";
      "alt-j" = "layout tiles horizontal vertical"; # toggle split direction

      # ── Focus (arrow keys, matching Hyprland SUPER+arrows) ──
      "alt-left" = "focus left";
      "alt-right" = "focus right";
      "alt-up" = "focus up";
      "alt-down" = "focus down";

      # ── Focus (vim-style hjkl) ──
      "alt-h" = "focus left";
      "alt-l" = "focus right";
      "alt-k" = "focus up";

      # ── Swap windows (matching Hyprland SUPER+SHIFT+arrows) ──
      "alt-shift-left" = "move left";
      "alt-shift-right" = "move right";
      "alt-shift-up" = "move up";
      "alt-shift-down" = "move down";

      # ── Swap windows (vim-style) ──
      "alt-shift-h" = "move left";
      "alt-shift-l" = "move right";
      "alt-shift-k" = "move up";
      "alt-shift-j" = "move down";

      # ── Resize ──
      "alt-minus" = "resize smart -50";
      "alt-equal" = "resize smart +50";

      # ── Switch workspaces (matching Hyprland SUPER+1-9,0) ──
      "alt-1" = "workspace 1";
      "alt-2" = "workspace 2";
      "alt-3" = "workspace 3";
      "alt-4" = "workspace 4";
      "alt-5" = "workspace 5";
      "alt-6" = "workspace 6";
      "alt-7" = "workspace 7";
      "alt-8" = "workspace 8";
      "alt-9" = "workspace 9";
      "alt-0" = "workspace 10";

      # ── Move window to workspace (matching Hyprland SUPER+SHIFT+1-9,0) ──
      "alt-shift-1" = "move-node-to-workspace 1";
      "alt-shift-2" = "move-node-to-workspace 2";
      "alt-shift-3" = "move-node-to-workspace 3";
      "alt-shift-4" = "move-node-to-workspace 4";
      "alt-shift-5" = "move-node-to-workspace 5";
      "alt-shift-6" = "move-node-to-workspace 6";
      "alt-shift-7" = "move-node-to-workspace 7";
      "alt-shift-8" = "move-node-to-workspace 8";
      "alt-shift-9" = "move-node-to-workspace 9";
      "alt-shift-0" = "move-node-to-workspace 10";

      # ── Cycle workspaces (matching Hyprland SUPER+TAB) ──
      "alt-tab" = "workspace next";
      "alt-shift-tab" = "workspace prev";
      "alt-ctrl-tab" = "workspace-back-and-forth";

      # ── Move workspace to monitor (matching Hyprland SUPER+SHIFT+ALT+arrows) ──
      "alt-shift-ctrl-left" = "move-workspace-to-monitor --wrap-around prev";
      "alt-shift-ctrl-right" = "move-workspace-to-monitor --wrap-around next";

      # ── Application launchers ──
      "alt-enter" = "exec-and-forget open -a Ghostty";
      "alt-shift-enter" = "exec-and-forget open -a 'Brave Browser'";

      # ── Flatten (analogous to Hyprland groups) ──
      "alt-shift-f" = "flatten-workspace-tree";

      # ── Resize mode ──
      "alt-r" = "mode resize";

      # ── Service mode ──
      "alt-shift-semicolon" = "mode service";
    };

    # Resize mode
    mode.resize.binding = {
      "left" = "resize width -50";
      "right" = "resize width +50";
      "up" = "resize height +50";
      "down" = "resize height -50";
      "h" = "resize width -50";
      "l" = "resize width +50";
      "k" = "resize height +50";
      "j" = "resize height -50";
      "enter" = "mode main";
      "esc" = "mode main";
    };

    # Service mode for reload etc.
    mode.service.binding = {
      "r" = [
        "reload-config"
        "mode main"
      ];
      "esc" = "mode main";
    };

    # Window rules: assign apps to specific workspaces
    on-window-detected = [
      {
        "if".app-id = "com.brave.Browser";
        run = "move-node-to-workspace 2";
      }
      {
        "if".app-id = "org.mozilla.firefox";
        run = "move-node-to-workspace 2";
      }
      {
        "if".app-id = "com.tinyspeck.slackmacgap";
        run = "move-node-to-workspace 3";
      }
      {
        "if".app-id = "com.hnc.Discord";
        run = "move-node-to-workspace 3";
      }
      {
        "if".app-id = "md.obsidian";
        run = [
          "move-node-to-workspace 4"
          "layout floating"
          "fullscreen"
        ];
      }
    ];
  };
}
