{
  inputs = { nixpkgs.url = "nixpkgs/nixos-unstable"; };

  outputs = inputs: {
    nixosConfigurations = {
      myNixOS = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
        ./configuration.nix
        ];
      };
    };
  };
}
