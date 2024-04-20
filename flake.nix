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
}@inputs: let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in {
    nixosConfigurations = {
      maple = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/maple
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.tnmt = import ./home/desktop;
          }
        ];
      };
      sunflower = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/sunflower
          nixos-hardware.nixosModules.microsoft-surface-go
          inputs.xremap-flake.nixosModules.default
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.tnmt = import ./home/desktop;
          }
        ];
      };
      vps03 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/vps03
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.tnmt = import ./home/server;
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
    homeConfigurations = {
      tnmt = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/server ];
      };
    };
  };
}
