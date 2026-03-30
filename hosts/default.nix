inputs:
let
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
      overlays,
      modules,
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;

          # FIX: How to solve this?
          permittedInsecurePackages = [ "electron-25.9.0" ];
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
        {
          home = {
            inherit username;
            homeDirectory = if system == "aarch64-darwin" then "/Users/${username}" else "/home/${username}";
            stateVersion = "25.05";
          };
          programs.home-manager.enable = true;
          programs.git.enable = true;

          sops = {
            defaultSopsFile = ../secrets/default.yaml;
            age.keyFile = "${if system == "aarch64-darwin" then "/Users/${username}" else "/home/${username}"}/.config/sops/age/keys.txt";
            secrets = {
              git_email = { };
              git_name = { };
              atuin_sync_address = { };
            };
          };
        }
      ];
    };
in
{
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
    test-vm = mkNixosSystem {
      system = "x86_64-linux";
      hostname = "test-vm";
      username = "tnmt";
      modules = [
        ./test-vm/nixos.nix
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
      overlays = [ ];
      modules = [ ./vps02/home-manager.nix ];
    };
    "tnmt@sunflower" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "tnmt";
      overlays = [ ];
      modules = [ ./sunflower/home-manager.nix ];
    };
    "tsunematsu@work_mac" = mkHomeManagerConfiguration {
      system = "aarch64-darwin";
      username = "tsunematsu";
      overlays = [ ];
      modules = [ ./work_mac/home-manager.nix ];
    };
    "tnmt@work_ubuntu" = mkHomeManagerConfiguration {
      system = "x86_64-linux";
      username = "tnmt";
      overlays = [ ];
      modules = [ ./work_ubuntu/home-manager.nix ];
    };
    "tnmt@hydrangea" = mkHomeManagerConfiguration {
      system = "aarch64-darwin";
      username = "tnmt";
      overlays = [ ];
      modules = [ ./hydrangea/home-manager.nix ];
    };
  };
}
