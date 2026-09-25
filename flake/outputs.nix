{
  inputs,
  self,
}:
let
  allSystems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];
  forAllSystems = inputs.nixpkgs.lib.genAttrs allSystems;
  pkgsFor = system: inputs.nixpkgs.legacyPackages.${system};
  hostConfigurations = import ../hosts inputs;
  formattersFor =
    pkgs: with pkgs; [
      nixfmt
      shfmt
      taplo
    ];
  development = import ./development.nix {
    inherit
      forAllSystems
      formattersFor
      pkgsFor
      ;
  };
in
{
  lib = import ../lib { inherit inputs; };

  nixosConfigurations = hostConfigurations.nixos;
  darwinConfigurations = hostConfigurations.darwin;
  homeConfigurations = hostConfigurations.home-manager;

  apps = import ./apps.nix {
    inherit
      forAllSystems
      pkgsFor
      self
      ;
  };

  inherit (development) devShells formatter;

  checks = import ./checks.nix {
    inherit
      forAllSystems
      inputs
      pkgsFor
      self
      ;
  };
}
