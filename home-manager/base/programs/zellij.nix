{ ... }:
{
  programs.zellij = {
    enable = true;
  };

  # Place the KDL config verbatim — too complex to translate to Nix
  xdg.configFile."zellij/config.kdl".source = ./zellij.kdl;
}
