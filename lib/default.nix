# Reusable builders for mynix-style host configurations.
#
# Exposed via `mynix.lib` so downstream flakes (e.g. tnmt-work-flake) can
# consume the same builders without duplicating overlay/specialArgs wiring.
{ inputs }:
let
  sopsShared = import ../profiles/common/sops-shared.nix;

  commonOverlays = [
    inputs.nix-claude-code.overlays.default
    (final: _prev: {
      inherit (inputs.nix-steipete-tools.packages.${final.stdenv.hostPlatform.system}) gogcli;
    })
    (final: prev: {
      # 自作パッケージは NUR アグリゲータの取り込み（数時間遅れ）を待たず
      # nur-tnmt input の直接参照で更新する。flake の packages 出力ではなく
      # NUR 規約の default.nix { pkgs } を使い、ホストの pkgs
      # (allowUnfree 等の config と overlay 込み) で評価する。
      inherit (import inputs.nur-tnmt { pkgs = final; })
        brave-origin
        ccpocket-bridge
        ccusage
        git-wt
        givy
        kagiana
        mo
        oneaws
        roots
        symbol-desktop-wallet
        ;
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
      theme = (import ../themes) "tokyonight-storm";
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
      extraSpecialArgs = mkSpecialArgs {
        inherit
          homeSopsFile
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
