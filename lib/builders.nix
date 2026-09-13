{
  commonOverlays,
  inputs,
  platforms,
  sopsShared,
  theme,
}:
let
  mkSpecialArgs =
    {
      homeSopsFile ? null,
      hostname ? null,
      system ? null,
      systemSopsFile ? null,
      username,
    }:
    {
      inherit
        commonOverlays
        inputs
        sopsShared
        theme
        username
        ;
    }
    // inputs.nixpkgs.lib.optionalAttrs (system != null) {
      homeDirectory = platforms.mkHomeDirectory username system;
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

  mkSystem =
    builder:
    {
      system,
      hostname,
      username,
      modules,
      homeSopsFile ? ../secrets/roles/personal.yaml,
      systemSopsFile ? ../secrets/hosts/${hostname}.yaml,
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
            system
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
      homeDirectory = platforms.mkHomeDirectory username system;
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs {
        inherit (inputs) nixpkgs;
        inherit system overlays;
      };
      extraSpecialArgs = mkSpecialArgs {
        inherit
          homeSopsFile
          system
          username
          ;
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
    mkDarwinSystem
    mkHomeManagerConfiguration
    mkHostConfigurations
    mkNamedConfigurations
    mkNixosSystem
    mkPkgs
    mkSpecialArgs
    mkSystem
    ;
}
