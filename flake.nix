{
  inputs = { nixpkgs.url = "nixpkgs/nixos-unstable"; };

  outputs =
  { nixpkgs
  , ...
  }@inputs: {
    nixosConfigurations = {
      maple = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/maple
        ];
      };
      sunflower = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/sunflower
        ];
      };
    };
  };
}
