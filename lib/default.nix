# Reusable builders for mynix-style host configurations.
#
# Exposed via `mynix.lib` so downstream flakes (e.g. tnmt-work-flake) can
# consume the same builders without duplicating overlay/specialArgs wiring.
{ inputs }:
let
  sopsShared = import ../profiles/common/sops-shared.nix;

  commonOverlays = [
    inputs.nur.overlays.default
    inputs.nix-claude-code.overlays.default
    (final: _prev: {
      inherit (inputs.nix-steipete-tools.packages.${final.stdenv.hostPlatform.system}) gogcli;
    })
    (final: prev: {
      inherit (final.nur.repos.tnmt) oneaws;
      inherit (final.nur.repos.tnmt) ccusage;
      inherit (final.nur.repos.tnmt) kagiana;
      inherit (final.nur.repos.tnmt) ccpocket-bridge;
      inherit (final.nur.repos.tnmt) roots;
      inherit (final.nur.repos.tnmt) git-wt;
      inherit (final.nur.repos.tnmt) givy;
      inherit (final.nur.repos.tnmt) herdr;
      inherit (final.nur.repos.tnmt) mo;
      inherit (final.nur.repos.tnmt) symbol-desktop-wallet;
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
      inherit
        commonOverlays
        inputs
        sopsShared
        username
        ;
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
      # Caller-supplied additions merged into specialArgs. Used by
      # downstream flakes (e.g. tnmt-work-flake) to inject `mynix` so host
      # modules can reference shared profiles via `"${inputs.mynix}/..."`.
      extraSpecialArgs ? { },
    }:
    builder {
      inherit system;
      modules = modules ++ [
        { nixpkgs.overlays = commonOverlays; }
      ];
      specialArgs =
        (mkSpecialArgs {
          inherit
            homeSopsFile
            hostname
            systemSopsFile
            username
            ;
        })
        // extraSpecialArgs;
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
        inherit (inputs) nixpkgs;
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
        (import ../home-manager/defaults.nix {
          inherit
            homeDirectory
            username
            ;
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
in
{
  inherit
    commonOverlays
    mkDarwinSystem
    mkHomeManagerConfiguration
    mkHostConfigurations
    mkNamedConfigurations
    mkNixosSystem
    mkPkgs
    mkSpecialArgs
    mkSystem
    sopsShared
    ;
}
