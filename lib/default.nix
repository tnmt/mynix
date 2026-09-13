# Public library entrypoint. Keep exported names stable for downstream flakes.
{ inputs }:
let
  nixpkgsLib = inputs.nixpkgs.lib;
  commonOverlays = import ./overlays.nix { inherit inputs; };
  platforms = import ./platforms.nix { lib = nixpkgsLib; };
  sopsShared = import ../profiles/common/sops-shared.nix;
  theme = (import ../themes) "tokyonight-storm";
  builders = import ./builders.nix {
    inherit
      commonOverlays
      inputs
      platforms
      sopsShared
      theme
      ;
  };
in
builders
// {
  inherit
    commonOverlays
    sopsShared
    ;
  inherit (platforms) mkHomeDirectory;
}
