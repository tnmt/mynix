{
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  programs.tmux = {
    enable = true;
    shortcut = "t";
    keyMode = "vi";
    clock24 = true;
    historyLimit = 10000;
    mouse = true;
    escapeTime = 0;
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      copycat
      fingers
      yank
      resurrect
      pain-control
      {
        plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
          name = "tokyo-night-tmux";
          pluginName = "tokyo-night-tmux";
          rtpFilePath = "tokyo-night.tmux";
          src = pkgs.fetchFromGitHub {
            owner = "janoamaral";
            repo = "tokyo-night-tmux";
            rev = "v1.8.1";
            sha256 = "sha256-tmS0MBANSsTg53E2GB0TnjwGcZXboTRFNeDE6Ehn+bM=";
          };
          # macOS /bin/bash は 3.2 で declare -A 非対応。スクリプトを Nix bash で起動させる。
          postPatch = ''
            find . \( -name "*.sh" -o -name "*.tmux" \) -exec \
              sed -i 's|#!/usr/bin/env bash|#!${pkgs.bash}/bin/bash|' {} +
          '';
        };
        extraConfig = ''
          set -g @tokyo-night-tmux_theme storm
          set -g @tokyo-night-tmux_window_id_style none
          set -g @tokyo-night-tmux_show_datetime 1
          set -g @tokyo-night-tmux_date_format YMD
          set -g @tokyo-night-tmux_time_format 24H
          set -g @tokyo-night-tmux_show_git 1
          set -g @tokyo-night-tmux_show_battery_widget 1
          ${if isDarwin then "" else ''set -g @tokyo-night-tmux_battery_name "BAT0"''}
          set -g @tokyo-night-tmux_show_hostname 1
        '';
      }
    ];

    extraConfig = ''
      set-option -ga terminal-overrides ",*:Tc"
      set-option -g renumber-windows on
      set -sg repeat-time 600

      # Clipboard: OSC52 で SSH越え・headless 対応。
      # ローカル環境では tmux-yank がランタイム検出 (pbcopy/wl-copy/xclip/clip.exe)。
      set -g set-clipboard on
      set -ga terminal-features "*:clipboard"
      set -g @yank_selection 'clipboard'
      set -g @yank_selection_mouse 'clipboard'
      set -g @yank_with_mouse on

      # Split panes
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Resize panes
      bind -r C-h resize-pane -L 5
      bind -r C-j resize-pane -D 5
      bind -r C-k resize-pane -U 5
      bind -r C-l resize-pane -R 5

      # Synchronize panes
      bind e setw synchronize-panes on \; display "Synchronize: ON"
      bind E setw synchronize-panes off \; display "Synchronize: OFF"

      # Vi copy mode (y / MouseDragEnd1Pane は tmux-yank が設定)
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi C-v send-keys -X rectangle-toggle

      # Quick window selection
      bind -r C-p previous-window
      bind -r C-n next-window

      set -g status-justify centre
      setw -g monitor-activity on
      set -g visual-activity off
      setw -g window-status-activity-style "none"
    '';
  };
}
