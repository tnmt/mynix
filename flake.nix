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

    xremap.url = "github:xremap/nix-flake";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # Hyprland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
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
    homeConfigurations = (import ./hosts inputs).home-manager;

    devShells = forAllSystems (system:
      let pkgs = import inputs.nixpkgs { inherit system; };
      in { default = pkgs.mkShell { packages = with pkgs; [ nh ]; }; });
  };
}
