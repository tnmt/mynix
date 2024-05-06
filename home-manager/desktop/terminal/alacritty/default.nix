{
  pkgs,
  ...
} :
  let
    fontsize = if pkgs.stdenv.isLinux then 12 else 16;
  in {
    programs.alacritty = {
      enable = true;

      settings = {
        env = {
          TERM = "xterm-256color";
        };
        window = {
          opacity = 0.9;
          blur = true;
        };
        font = {
          size = fontsize;
          normal = {
            family = "MesloLGS Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "MesloLGS Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "MesloLGS Nerd Font";
            style = "Bold";
          };
        };
        scrolling.history = 100000;
        selection.save_to_clipboard = true;
        ## tokyonight
        #colors = {
        #  primary = {
        #    background = "#1a1b26";
        #    foreground = "#a9b1d6";
        #  };
        #  normal = {
        #    black   = "#32344a";
        #    red     = "#f7768e";
        #    green   = "#9ece6a";
        #    yellow  = "#e0af68";
        #    blue    = "#7aa2f7";
        #    magenta = "#ad8ee6";
        #    cyan    = "#449dab";
        #    white   = "#787c99";
        #  };
        #  bright = {
        #    black   = "#444b6a";
        #    red     = "#ff7a93";
        #    green   = "#b9f27c";
        #    yellow  = "#ff9e64";
        #    blue    = "#7da6ff";
        #    magenta = "#bb9af7";
        #    cyan    = "#0db9d7";
        #    white   = "#acb0d0";
        #  };
        #};
        ## tokyonight-storm
        colors = {
          primary = {
            background = "#24283b";
            foreground = "#a9b1d6";
          };
          normal = {
            black   = "#32344a";
            red     = "#f7768e";
            green   = "#9ece6a";
            yellow  = "#e0af68";
            blue    = "#7aa2f7";
            magenta = "#ad8ee6";
            cyan    = "#449dab";
            white   = "#9699a8";
          };
          bright = {
            black   = "#444b6a";
            red     = "#ff7a93";
            green   = "#b9f27c";
            yellow  = "#ff9e64";
            blue    = "#7da6ff";
            magenta = "#bb9af7";
            cyan    = "#0db9d7";
            white   = "#acb0d0";
          };
        };
        keyboard.bindings = [
          { key = "N"; mods = "Control|Shift"; action = "SpawnNewInstance"; }
        ];
      };
    };
}
