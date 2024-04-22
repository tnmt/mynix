{ pkgs, ... } : {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ./starship/starship.toml);
  };
}
