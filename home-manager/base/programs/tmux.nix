{
  pkgs,
  lib,
  theme,
  ...
}:
let
  isDarwin = pkgs.stdenv.isDarwin;
  themeSrc = pkgs.fetchFromGitHub theme.src;

  # Battery status for status bar (only shows output when battery exists)
  # Use printf with unicode escapes since Nix '' strings strip the raw glyphs
  tmux-battery = pkgs.writeShellScript "tmux-battery" ''
    bat=/sys/class/power_supply/BAT0
    [ -d "$bat" ] || exit 0
    cap=$(cat "$bat/capacity" 2>/dev/null) || exit 0
    status=$(cat "$bat/status" 2>/dev/null)
    if [ "$status" = "Charging" ]; then
      icon=$(printf '\xf3\xb0\x82\x84') # nf-md-battery_charging U+F0084
    elif [ "$cap" -ge 80 ]; then
      icon=$(printf '\xf3\xb0\x81\xb9') # nf-md-battery U+F0079
    elif [ "$cap" -ge 60 ]; then
      icon=$(printf '\xf3\xb0\x81\xbb') # nf-md-battery_60 U+F007B
    elif [ "$cap" -ge 40 ]; then
      icon=$(printf '\xf3\xb0\x81\xba') # nf-md-battery_40 U+F007A
    elif [ "$cap" -ge 20 ]; then
      icon=$(printf '\xf3\xb0\x81\xb8') # nf-md-battery_20 U+F0078
    else
      icon=$(printf '\xf3\xb0\x81\xb6') # nf-md-battery_alert U+F0076
    fi
    echo "$icon $cap%%"
  '';
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

      # Active pane border (override theme default for better visibility)
      set -g pane-active-border-style "fg=${theme.accent},bold"
      set -g pane-border-style "fg=${theme.color8}"

      # Status bar (override theme status-right to add battery to hostname)
      set -g status-justify centre
      setw -g monitor-activity on
      set -g visual-activity off
      set -g status-right-length "200"
      set -g status-right "#[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=${theme.accent},bg=#1f2335] #{prefix_highlight} #[fg=${theme.color8},bg=#1f2335,nobold,nounderscore,noitalics]#[fg=${theme.accent},bg=${theme.color8}] %Y-%m-%d  %H:%M #[fg=${theme.accent},bg=${theme.color8},nobold,nounderscore,noitalics]#[fg=${theme.color0},bg=${theme.accent},bold] #h #(${tmux-battery}) "
    '';
  };
}
