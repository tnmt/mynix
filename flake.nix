{
  description = "NixOS & homa-manager configurations of tnmt";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.05";
    nixpkgs-darwin.url = "nixpkgs/nixpkgs-25.05-darwin";

    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap.url = "github:xremap/nix-flake";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/eabf2ecbb69a6d501b4e85117f4799e0efb0e889";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ccusage.url = "github:tnmt/ccusage-flake";
    oneaws.url = "github:tnmt/oneaws-flake";
    # Hyprland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
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
      nixosConfigurations = (import ./hosts inputs).nixos;
      darwinConfigurations = (import ./hosts inputs).darwin;
      homeConfigurations = (import ./hosts inputs).home-manager;

      apps.x86_64-linux = {
        # Run with: nix run .#dahlia-vm
        dahlia-vm = {
          type = "app";
          program = "${self.nixosConfigurations.dahlia.config.system.build.vm}/bin/run-dahlia-vm";
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
