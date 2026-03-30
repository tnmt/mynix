# Theme color palette provider
# Usage: (import ./themes) "tokyonight-storm"
# Returns an attribute set with all color values for use across programs.
name:
let
  themes = {
    tokyonight-storm = import ./tokyonight-storm.nix;
  };
in
themes.${name}
