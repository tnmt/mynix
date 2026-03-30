{ ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # Place the full starship.toml verbatim — it's 264 lines with a custom
  # palette and nerd font symbols; translating to Nix attrset is error-prone.
  xdg.configFile."starship.toml".source = ./starship.toml;
}
