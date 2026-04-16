inputs:
let
  commonOverlays = [
    inputs.nur.overlays.default
    (final: prev: {
      oneaws = final.nur.repos.tnmt.oneaws;
      ccusage = final.nur.repos.tnmt.ccusage;
      gogcli = final.nur.repos.tnmt.gogcli;
      tokyonight-gtk-theme = prev.tokyonight-gtk-theme.override {
        tweakVariants = [ "storm" ];
        colorVariants = [ "dark" ];
        iconVariants = [ "Dark" ];
      };
    })
  ];

  mkSpecialArgs =
    {
      hostname ? null,
      username,
    }:
    {
      inherit inputs username;
    }
    // inputs.nixpkgs.lib.optionalAttrs (hostname != null) {
      inherit hostname;
    };

  mkPkgs =
    {
      nixpkgs,
      system,
      overlays ? commonOverlays,
    }:
    import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };

  mkHomeDirectory =
    username: system: if system == "aarch64-darwin" then "/Users/${username}" else "/home/${username}";

  mkHomeManagerDefaults =
    {
      system,
      username,
      sopsFile,
    }:
    {
      pkgs,
      ...
    }:
    let
      homeDirectory = mkHomeDirectory username system;
    in
    {
      home = {
        inherit username homeDirectory;
        stateVersion = "25.05";
      };

      nix.package = pkgs.nix;
      programs.home-manager.enable = true;
      programs.git.enable = true;

      sops = {
        defaultSopsFile = sopsFile;
        age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
        secrets = {
          git_email = { };
          git_name = { };
          atuin_sync_address = {
            sopsFile = ../secrets/common.yaml;
          };
        };
      };
    };

  mkNixosSystem =
    {
      system,
      hostname,
      username,
      modules,
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = modules ++ [
        { nixpkgs.overlays = commonOverlays; }
      ];
      specialArgs = mkSpecialArgs {
        inherit hostname username;
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
      pkgs = mkPkgs {
        nixpkgs = inputs.nixpkgs;
        inherit system overlays;
      };
      extraSpecialArgs = {
        inherit inputs username;
        theme = (import ../themes) "tokyonight-storm";
        pkgs-stable = mkPkgs {
          nixpkgs = inputs.nixpkgs-stable;
          inherit system overlays;
        };
      };
      modules = modules ++ [
        inputs.sops-nix.homeManagerModules.sops
        (mkHomeManagerDefaults {
          inherit system username sopsFile;
        })
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
      specialArgs = mkSpecialArgs {
        inherit hostname username;
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
    hydrangea = mkDarwinSystem {
      system = "aarch64-darwin";
      hostname = "hydrangea";
      username = "tnmt";
      modules = [ ./hydrangea/darwin.nix ];
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
