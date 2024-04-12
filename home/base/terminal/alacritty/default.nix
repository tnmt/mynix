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
      scrolling.history = 100000;
      selection.save_to_clipboard = true;
      mouse.hide_when_typing = true;
    };
  };
}
