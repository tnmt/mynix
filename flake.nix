{
  description = "NixOS & home-manager configurations of tnmt";

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

    msgvault = {
      url = "github:kenn-io/msgvault";
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
      formattersFor =
        pkgs: with pkgs; [
          nixfmt
          taplo
        ];
    in
    {
      lib = import ./lib { inherit inputs; };

      nixosConfigurations = (import ./hosts inputs).nixos;
      darwinConfigurations = (import ./hosts inputs).darwin;
      homeConfigurations = (import ./hosts inputs).home-manager;

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
    };
}
