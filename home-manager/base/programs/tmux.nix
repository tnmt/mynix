{
  pkgs,
  lib,
  theme,
  ...
}:
let
  isDarwin = pkgs.stdenv.isDarwin;
  themeSrc = pkgs.fetchFromGitHub theme.src;
in
{
  programs.tmux = {
    enable = true;
    shortcut = "t";
    keyMode = "vi";
    clock24 = true;
    historyLimit = 10000;
    mouse = false;
    escapeTime = 0;
    terminal = "screen-256color";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      copycat
      fingers
      yank
      resurrect
      pain-control
      prefix-highlight
    ];

    extraConfig = ''
      source-file ${themeSrc}/${theme.extras.tmux}

      set-option -ga terminal-overrides ",$TERM:Tc"
      set-option -g renumber-windows on
      set -sg repeat-time 600

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

      # Vi copy mode
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${
        if isDarwin then "pbcopy" else "wl-copy"
      }"
      bind -T copy-mode-vi C-v send-keys -X rectangle-toggle

      # Quick window selection
      bind -r C-p previous-window
      bind -r C-n next-window

      # Status
      set -g status-justify centre
      setw -g monitor-activity on
      set -g visual-activity off
    '';
  };
}
