{ pkgs
, ...
}: {
  programs.tmux = {
    enable = true;
    shortcut = "t";
    keyMode = "vi";
    clock24 = true;
    historyLimit = 10000;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      copycat
      yank
      resurrect
      pain-control
      onedark-theme
    ];

    extraConfig = ''
      set-option -g renumber-windows on

      bind e setw synchronize-panes on
      bind E setw synchronize-panes off
      '';
  };

}
