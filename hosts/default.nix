inputs:
let
  commonOverlays = [
    (final: prev: {
      oneaws = inputs.oneaws.packages.${final.stdenv.hostPlatform.system}.default;
      ccusage = inputs.ccusage.packages.${final.stdenv.hostPlatform.system}.default;
    })
  ];

  mkNixosSystem =
    {
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

  mkHomeManagerConfiguration =
    {
      system,
      username,
      overlays ? commonOverlays,
      modules,
      sopsFile ? ../secrets/default.yaml,
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
        };
      };
      extraSpecialArgs = {
        inherit inputs username;
        theme = (import ../themes) "tokyonight-storm";
        pkgs-stable = import inputs.nixpkgs-stable {
          inherit system overlays;
          config = {
            allowUnfree = true;
          };
        };
      };
      modules = modules ++ [
        inputs.sops-nix.homeManagerModules.sops
        (
          { pkgs, ... }:
          {
            home = {
              inherit username;
              homeDirectory = if system == "aarch64-darwin" then "/Users/${username}" else "/home/${username}";
              stateVersion = "25.05";
            };
            nix.package = pkgs.nix;
            programs.home-manager.enable = true;
            programs.git.enable = true;

            sops = {
              defaultSopsFile = sopsFile;
              age.keyFile = "${
                if system == "aarch64-darwin" then "/Users/${username}" else "/home/${username}"
              }/.config/sops/age/keys.txt";
              secrets = {
                git_email = { };
                git_name = { };
                atuin_sync_address = {
                  sopsFile = ../secrets/common.yaml;
                };
              };
            };
          }
        )
      ];
    };
  mkDarwinSystem =
    {
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
in
{
  darwin = {
    work_mac = mkDarwinSystem {
      system = "aarch64-darwin";
      hostname = "work_mac";
      username = "tsunematsu";
      modules = [ ./work_mac/darwin.nix ];
    };
  };

  nixos = {
    sunflower = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "sunflower";
      username = "tnmt";
      modules = [
        ./sunflower/nixos.nix
        {
          system.stateVersion = "25.05";
          wsl.enable = true;
        }
      ];
    };
    dahlia = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "dahlia";
      username = "tnmt";
      modules = [
        ./dahlia/nixos.nix
        {
          system.stateVersion = "25.05";
        }
      ];
    };
  };

  home-manager = {
    "tnmt@vps02" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "tnmt";
      modules = [ ./vps02/home-manager.nix ];
    };
    "tsunematsu@work_mac" = mkHomeManagerConfiguration {
      system = "aarch64-darwin";
      username = "tsunematsu";
      sopsFile = ../secrets/work_mac.yaml;
      modules = [ ./work_mac/home-manager.nix ];
    };
    "tnmt@work_ubuntu" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "tnmt";
      modules = [ ./work_ubuntu/home-manager.nix ];
    };
    "tnmt@hydrangea" = mkHomeManagerConfiguration {
      system = "aarch64-darwin";
      username = "tnmt";
      modules = [ ./hydrangea/home-manager.nix ];
    };
  };
}
