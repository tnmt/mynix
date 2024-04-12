{ ... }: {
  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        size = 15;
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
    };
  };
}
