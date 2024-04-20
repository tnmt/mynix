{ ... }: {
  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        size = 16;
        normal = {
          family = "MesloLGS NF";
          style = "Regular";
        };
        bold = {
          family = "MesloLGS NF";
          style = "Bold";
        };
        italic = {
          family = "MesloLGS NF";
          style = "Bold";
        };
      };
      scrolling.history = 100000;
      selection.save_to_clipboard = true;
      colors = {
        primary = {
          background = "#282c34";
          foreground = "#abb2bf";
        };
        normal = {
          black   = "#1e2127";
          red     = "#e06c75";
          green   = "#98c379";
          yellow  = "#d19a66";
          blue    = "#61afef";
          magenta = "#c678dd";
          cyan    = "#56b6c2";
          white   = "#abb2bf";
        };
        bright = {
          black   = "#5c6370";
          red     = "#e06c75";
          green   = "#98c379";
          yellow  = "#d19a66";
          blue    = "#61afef";
          magenta = "#c678dd";
          cyan    = "#56b6c2";
          white   = "#ffffff";
        };
      };
      key_bindings = [
        { key = "N"; mods = "Control|Shift"; action = "SpawnNewInstance"; }
      ];
    };
  };
}
