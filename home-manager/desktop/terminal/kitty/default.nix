{ terminal, theme, ... }:
{
  programs.kitty = {
    enable = true;
    themeFile = theme.kitty;
    font = {
      name = terminal.font.name;
      size = terminal.font.size;
    };
  };
}
