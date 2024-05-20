{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shortcut = "t";
    keyMode = "vi";
    clock24 = true;
    terminal = "tmux-256color";
    historyLimit = 10000;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      copycat
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
            rev = "v1.5";
            sha256 = "sha256-yho2irPSwdRkNNwU7HZzN5dvspjDHWl75NlpS3uwz8M=";
          };
        };
        extraConfig = ''
          set -g @tokyo-night-tmux_window_id_style none
          set -g @tokyo-night-tmux_date_format YMD
          set -g @tokyo-night-tmux_time_format 24H
        '';
      }
    ];

    extraConfig = ''
      set-option -ga terminal-overrides ",$TERM:Tc"

      set-option -g renumber-windows on

      bind e setw synchronize-panes on
      bind E setw synchronize-panes off
    '';
  };
}
