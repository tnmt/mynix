{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
  { nixpkgs,
    nixos-hardware,
    ...
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
          # nixos-hardware.nixosModules.microsoft-surface-go
        ];
      };
    };
  };
}
