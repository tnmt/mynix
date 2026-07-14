# Theme color palette provider
# Usage: (import ./themes) "tokyonight-storm"
# Returns an attribute set with all color values for use across programs,
# plus `srcDrv pkgs` fetching the upstream theme repo (extras/ etc.).
name:
let
  themes = {
    tokyonight-storm = import ./tokyonight-storm.nix;
  };
  theme = themes.${name};
in
theme
// {
  srcDrv = pkgs: pkgs.fetchFromGitHub theme.src;
}
