{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
  { nixpkgs
  , nixos-hardware
  , home-manager
  , ...
  }@inputs: {
    nixosConfigurations = {
      maple = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/maple
          home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.tnmt = import ./home/linux;
            }
        ];
      };
      sunflower = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/sunflower
          home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.tnmt = import ./home/linux;
            }
        ];
      };
    };
  };

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
    auto-optimise-store = true;

    eval-cache = true;

    substituters = [ "https://cache.nixos.org/" ];
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
