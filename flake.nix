{
  inputs = { nixpkgs.url = "nixpkgs/nixos-22.11"; };

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
