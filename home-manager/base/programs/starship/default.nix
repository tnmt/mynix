{ theme, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # Base config with Nerd Font symbols is kept as a TOML file to preserve
  # Unicode glyphs that break in Nix '' strings.
  # The palette section is appended from theme variables.
  xdg.configFile."starship.toml".text = builtins.readFile ./starship.toml + ''

    [palettes.tokyonight_storm]
    red = "${theme.color1}"
    orange = "${theme.orange}"
    yellow = "${theme.color3}"
    green = "${theme.color2}"
    teal = "${theme.teal}"
    cyan = "${theme.color6}"
    blue = "${theme.accent}"
    purple = "${theme.color5}"
    magenta = "${theme.magenta}"
    fg = "${theme.foreground}"
    fg_dark = "${theme.color7}"
    comment = "${theme.comment}"
    dark5 = "${theme.dark5}"
    terminal_black = "${theme.color8}"
    bg_highlight = "${theme.bg_highlight}"
    bg = "${theme.background}"
    bg_dark = "${theme.bg_dark}"
  '';
}
