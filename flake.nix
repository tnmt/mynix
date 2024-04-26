{
  description = "NixOS & homa-manager configurations of tnmt";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    nixpkgs-darwin.url = "nixpkgs/nixpkgs-23.11-darwin";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap-flake.url = "github:xremap/nix-flake";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    hyprsome.url = "github:sopa0/hyprsome";
  };

  outputs = inputs: let
    allSystems = [
      "x86_64-linux" # 64-bit x86 Linux
      "aarch64-darwin" # 64-bit ARM macOS
    ];
    forAllSystems = inputs.nixpkgs.lib.genAttrs allSystems;
  in {
    packages = forAllSystems (system: import ./pkgs inputs.nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: inputs.nixpkgs.legacyPackages.${system}.nixfmt);

    nixosConfigurations = (import ./hosts inputs).nixos;
    darwinConfigurations = (import ./hosts inputs).darwin;
    homeConfigurations = (import ./hosts inputs).home-manager;

    devShells = forAllSystems (system: let
      pkgs = import inputs.nixpkgs {inherit system;};
      scripts = with pkgs; [
        (writeScriptBin "switch-home" ''
          home-manager switch --flake ".#$@"
        '')
        (writeScriptBin "switch-nixos" ''
          sudo nixos-rebuild switch --flake ".#$@"
        '')
        (writeScriptBin "switch-darwin" ''
	  nix build .#darwinConfigurations.$@.system --extra-experimental-features 'nix-command flakes' --debug
	  ./result/sw/bin/darwin-rebuild switch --flake ".#$@"
        '')
      ];
      devPkgs = [
      ];
    in {
      default = pkgs.mkShell {
        packages = scripts ++ devPkgs;
      };
    });
  };
}
