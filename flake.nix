{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-darwin.url = "nixpkgs/nixpkgs-23.11-darwin";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs =
  { nixpkgs
  , darwin
  , nixos-hardware
  , home-manager
  , lanzaboote
  , nixos-wsl
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
          nixos-hardware.nixosModules.microsoft-surface-go
          inputs.xremap-flake.nixosModules.default
          home-manager.nixosModules.home-manager
          lanzaboote.nixosModules.lanzaboote
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.tnmt = import ./home/linux;
            }
        ];
      };
      hydrangea = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/hydrangea
	        nixos-wsl.nixosModules.default
	        {
	          system.stateVersion = "23.11";
	          wsl.enable = true;
	        }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.tnmt = import ./home/server;
          }
        ];
      };
      vps02 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/vps02
          #home-manager.nixosModules.home-manager
          #  {
          #    home-manager.useGlobalPkgs = true;
          #    home-manager.useUserPackages = true;
          #    home-manager.users.tnmt = import ./home/linux;
          #  }
        ];
      };
    };
    darwinConfigurations = {
      work = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/work
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.tsunematsu = import ./home/darwin;
          }
        ];
      };
      goldmoon = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/goldmoon
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.tnmt = import ./home/darwin;
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
