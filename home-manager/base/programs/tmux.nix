{ pkgs
, ...
}: {
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
        plugin = onedark-theme;
        extraConfig = ''
          set -g @onedark_date_format "%Y/%m/%d"
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
