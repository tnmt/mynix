inputs: let
  mkNixosSystem = {
    system,
    hostname,
    username,
    modules,
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system modules;
      specialArgs = {
        inherit inputs hostname username;
      };
    };

  mkDarwinSystem = {
    system,
    hostname,
    username,
    modules,
  }:
    inputs.darwin.lib.darwinSystem {
      inherit system modules;
      specialArgs = {
        inherit inputs hostname username;
      };
    };

  mkHomeManagerConfiguration = {
    system,
    username,
    overlays,
    modules,
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;

          # FIX: How to solve this?
          permittedInsecurePackages = [
            "electron-25.9.0"
          ];
        };
      };
      extraSpecialArgs = {
        inherit inputs username;
        theme = (import ../themes) "tokyonight-moon";
        pkgs-stable = import inputs.nixpkgs-stable {
          inherit system overlays;
          config = {
            allowUnfree = true;
          };
        };
      };
      modules =
        modules
        ++ [
          {
            home = {
              inherit username;
              homeDirectory = "/home/${username}";
              stateVersion = "23.11";
            };
            programs.home-manager.enable = true;
            programs.git.enable = true;
          }
        ];
    };
in {
  nixos = {
    maple = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "maple";
      username = "tnmt";
      modules = [
        ./maple/nixos.nix
      ];
    };
    sunflower = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "sunflower";
      username = "tnmt";
      modules = [
        ./maple/nixos.nix
        inputs.nixos-hardware.nixosModules.microsoft-surface-go
        inputs.xremap-flake.nixosModules.default
        inputs.lanzaboote.nixosModules.lanzaboote
      ];
    };
    vps03 = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "vps03";
      username = "tnmt";
      modules = [
        ./vps03/nixos.nix
      ];
    };
    hydrangea = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "hydrangea";
      username = "tnmt";
      modules = [
        ./hydrangea/nixos.nix
        inputs.nixos-wsl.nixosModules.default
	{
	  system.stateVersion = "23.11";
	  wsl.enable = true;
	}
      ];
    };
  };

  darwin = {
    work = mkDarwinSystem {
      system = "aarch64-darwin";
      username = "tsunematsu";
      modules = [
        ./work/darwin.nix
      ];
    };
  };

  home-manager = {
    "tnmt@maple" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "tnmt";
      modules = [
        ./maple/home-manager.nix
      ];
    };
    "tnmt@sunflower" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "tnmt";
      modules = [
        ./sunflower/home-manager.nix
      ];
    };
    "tnmt@vps03" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "tnmt";
      modules = [
        ./vps03/home-manager.nix
      ];
    };
    "tnmt@hydrangea" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "tnmt";
      modules = [
        ./hydrangea/home-manager.nix
      ];
    };
  };
}
