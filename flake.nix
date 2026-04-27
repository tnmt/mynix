{
  description = "NixOS & home-manager configurations of tnmt";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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

    nur.url = "github:nix-community/NUR";

    nur-tnmt = {
      url = "github:tnmt/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, ... }:
    let
      allSystems = [
        "x86_64-linux" # 64-bit x86 Linux
        "aarch64-darwin" # 64-bit ARM macOS
      ];
      forAllSystems = inputs.nixpkgs.lib.genAttrs allSystems;
    in
    {
      lib = import ./lib { inherit inputs; };

      nixosConfigurations = (import ./hosts inputs).nixos;
      darwinConfigurations = (import ./hosts inputs).darwin;
      homeConfigurations = (import ./hosts inputs).home-manager;

      apps.x86_64-linux = {
        # Run with: nix run .#dahlia-vm
        dahlia-vm = {
          type = "app";
          program = "${self.nixosConfigurations.dahlia.config.system.build.vm}/bin/run-dahlia-vm";
          meta.description = "Run dahlia NixOS VM";
        };
      };

      devShells = forAllSystems (
        system:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          formatters = with pkgs; [
            nixfmt
            taplo
          ];
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
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          formatters = with pkgs; [
            nixfmt
            taplo
          ];
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
