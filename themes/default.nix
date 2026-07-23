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
  # Fetch the upstream theme repo via the Nix evaluator's builtin fetcher rather
  # than pkgs.fetchFromGitHub. Modules read extras/ files with builtins.readFile,
  # which turns the source into an IFD (import from derivation). A fetchFromGitHub
  # source is a fixed-output derivation bound to pkgs.system, so evaluating the
  # darwin config on a linux CI runner tries to *build* an aarch64-darwin FOD and
  # fails with "platform mismatch". builtins.fetchTree is platform-independent.
  srcDrv =
    _pkgs:
    builtins.fetchTree {
      type = "github";
      inherit (theme.src) owner repo rev;
      narHash = theme.src.hash;
    };
}
