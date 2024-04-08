{
  inputs = { nixpkgs.url = "nixpkgs/nixos-unstable"; };

  outputs =
  { nixpkgs
  , ...
  }@inputs: {
    nixosConfigurations = {
      myNixOS = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
      sunflower = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuratio_sunflower.nix
        ];
      };
    };
  };
}
