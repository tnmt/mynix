{
  description = "NixOS & home-manager configurations of tnmt";

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-darwin = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur-tnmt = {
      url = "github:tnmt/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprdynamicmonitors = {
      url = "github:fiffeek/hyprdynamicmonitors";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-claude-code.url = "github:ryoppippi/nix-claude-code";

    nix-steipete-tools = {
      url = "github:openclaw/nix-steipete-tools";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # msgvault is packaged in nur-tnmt (upstream dropped its own Nix flake
    # in kenn-io/msgvault#767). Only bun2nix (for the web frontend build)
    # needs to be wired through from here.
    bun2nix = {
      url = "github:nix-community/bun2nix/2.1.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Private repo: shizuku (local memory server). Plain github.com URL
    # is fine on the single-key mynix hosts (sunflower/dahlia). Downstream
    # flakes with multi-account SSH (e.g. tnmt-work-flake) declare their
    # own shizuku input via an alias URL.
    shizuku = {
      url = "git+ssh://git@github.com/tnmt/shizuku";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, ... }:
    let
      allSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = inputs.nixpkgs.lib.genAttrs allSystems;
      pkgsFor = system: inputs.nixpkgs.legacyPackages.${system};
      hostConfigurations = import ./hosts inputs;
      formattersFor =
        pkgs: with pkgs; [
          nixfmt
          taplo
        ];
    in
    {
      lib = import ./lib { inherit inputs; };

      nixosConfigurations = hostConfigurations.nixos;
      darwinConfigurations = hostConfigurations.darwin;
      homeConfigurations = hostConfigurations.home-manager;

      apps = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
          rebuildCmd = if pkgs.lib.hasSuffix "darwin" system then "darwin" else "os";
          switch = pkgs.writeShellApplication {
            name = "switch";
            runtimeInputs = [ pkgs.nh ];
            text = ''
              host="''${HOSTNAME:-$(uname -n)}"
              host="''${host%%.*}"
              exec nh ${rebuildCmd} switch . -H "$host" "$@"
            '';
          };
        in
        {
          # Extra args after `--` pass through to nh.
          switch = {
            type = "app";
            program = "${switch}/bin/switch";
            meta.description = "Rebuild & activate current host (auto-detect NixOS/Darwin)";
          };
        }
        // pkgs.lib.optionalAttrs (system == "x86_64-linux") {
          dahlia-vm = {
            type = "app";
            program = "${self.nixosConfigurations.dahlia.config.system.build.vm}/bin/run-dahlia-vm";
            meta.description = "Run dahlia NixOS VM";
          };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
          formatters = formattersFor pkgs;
          scripts = [
            (pkgs.writeScriptBin "update-input" ''
              nix flake lock --override-input "$1" "$2"
            '')
          ];
        in
        {
          default = pkgs.mkShell {
            packages =
              (with pkgs; [
                nh
                cachix
              ])
              ++ formatters
              ++ scripts;
          };
        }
      );
      formatter = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
          formatters = formattersFor pkgs;
          format = pkgs.writeScriptBin "format" ''
            #!${pkgs.runtimeShell}
            PATH=$PATH:${pkgs.lib.makeBinPath formatters}
            ${pkgs.treefmt}/bin/treefmt --config-file ${./treefmt.toml}
          '';
        in
        format
      );

      checks = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
          mynixLib = import ./lib { inherit inputs; };
          platformAssertions =
            assert mynixLib.mkHomeDirectory "test" "x86_64-linux" == "/home/test";
            assert mynixLib.mkHomeDirectory "test" "x86_64-darwin" == "/Users/test";
            assert mynixLib.mkHomeDirectory "test" "aarch64-darwin" == "/Users/test";
            true;
          givyAssertions =
            if system == "x86_64-linux" then
              assert !self.nixosConfigurations.sunflower.config.home-manager.users.tnmt.programs.givy.enable;
              assert self.nixosConfigurations.dahlia.config.home-manager.users.tnmt.programs.givy.enable;
              true
            else
              true;
        in
        {
          architecture =
            assert platformAssertions;
            assert givyAssertions;
            pkgs.runCommand "mynix-architecture-check" { } "touch $out";
        }
      );
    };
}
