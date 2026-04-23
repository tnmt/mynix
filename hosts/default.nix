inputs:
let
  commonOverlays = [
    inputs.nur.overlays.default
    (final: prev: {
      oneaws = final.nur.repos.tnmt.oneaws;
      ccusage = final.nur.repos.tnmt.ccusage;
      gogcli = final.nur.repos.tnmt.gogcli;
      kagiana = final.nur.repos.tnmt.kagiana;
      ccpocket-bridge = final.nur.repos.tnmt.ccpocket-bridge;
      tokyonight-gtk-theme = prev.tokyonight-gtk-theme.override {
        tweakVariants = [ "storm" ];
        colorVariants = [ "dark" ];
        iconVariants = [ "Dark" ];
      };
    })
  ];

  mkSpecialArgs =
    {
      homeSopsFile ? null,
      hostname ? null,
      systemSopsFile ? null,
      username,
    }:
    {
      inherit commonOverlays inputs username;
    }
    // inputs.nixpkgs.lib.optionalAttrs (hostname != null) {
      inherit hostname;
    }
    // inputs.nixpkgs.lib.optionalAttrs (homeSopsFile != null) {
      inherit homeSopsFile;
    }
    // inputs.nixpkgs.lib.optionalAttrs (systemSopsFile != null) {
      inherit systemSopsFile;
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

  mkSystem =
    builder:
    {
      system,
      hostname,
      username,
      modules,
      homeSopsFile ? ../secrets/roles/personal.yaml,
      systemSopsFile ? ../secrets/hosts/${hostname}.yaml,
    }:
    builder {
      inherit system;
      modules = modules ++ [
        { nixpkgs.overlays = commonOverlays; }
      ];
      specialArgs = mkSpecialArgs {
        inherit
          homeSopsFile
          hostname
          systemSopsFile
          username
          ;
      };
    };

  mkNixosSystem = mkSystem inputs.nixpkgs.lib.nixosSystem;
  mkDarwinSystem = mkSystem inputs.darwin.lib.darwinSystem;

  mkHomeManagerConfiguration =
    {
      system,
      username,
      overlays ? commonOverlays,
      modules,
      homeSopsFile ? ../secrets/roles/personal.yaml,
    }:
    let
      homeDirectory = mkHomeDirectory username system;
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs {
        nixpkgs = inputs.nixpkgs;
        inherit system overlays;
      };
      extraSpecialArgs =
        (mkSpecialArgs {
          inherit
            homeSopsFile
            username
            ;
        })
        // {
          theme = (import ../themes) "tokyonight-storm";
        };
      modules = modules ++ [
        inputs.sops-nix.homeManagerModules.sops
        (import ../home-manager/defaults.nix {
          inherit homeDirectory homeSopsFile username;
        })
      ];
    };

  mkHostConfigurations =
    builder: hosts:
    inputs.nixpkgs.lib.mapAttrs (
      hostname: args:
      builder (
        args
        // {
          inherit hostname;
        }
      )
    ) hosts;

  mkNamedConfigurations = builder: hosts: inputs.nixpkgs.lib.mapAttrs (_: builder) hosts;

  darwinHosts = {
    work_mac = {
      system = "aarch64-darwin";
      username = "tsunematsu";
      homeSopsFile = ../secrets/roles/work.yaml;
      modules = [ ./work_mac/darwin.nix ];
    };
    hydrangea = {
      system = "aarch64-darwin";
      username = "tnmt";
      modules = [ ./hydrangea/darwin.nix ];
    };
  };

  nixosHosts = {
    sunflower = {
      system = "x86_64-linux";
      username = "tnmt";
      modules = [
        ./sunflower/nixos.nix
        {
          system.stateVersion = "25.05";
          wsl.enable = true;
        }
      ];
    };
    dahlia = {
      system = "x86_64-linux";
      username = "tnmt";
      modules = [
        ./dahlia/nixos.nix
        {
          system.stateVersion = "25.05";
        }
      ];
    };
    work_vm = {
      system = "x86_64-linux";
      username = "tnmt";
      homeSopsFile = ../secrets/roles/work.yaml;
      modules = [ ./work_vm/nixos.nix ];
    };
  };

  # Standalone Home Manager outputs are kept for compatibility with flake
  # consumers, but all current hosts use NixOS/nix-darwin integration.
  homeManagerHosts = { };
in
{
  darwin = mkHostConfigurations mkDarwinSystem darwinHosts;
  nixos = mkHostConfigurations mkNixosSystem nixosHosts;
  home-manager = mkNamedConfigurations mkHomeManagerConfiguration homeManagerHosts;
}
