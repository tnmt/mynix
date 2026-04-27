inputs:
let
  lib = import ../lib { inherit inputs; };

  inherit (lib)
    mkDarwinSystem
    mkHomeManagerConfiguration
    mkHostConfigurations
    mkNamedConfigurations
    mkNixosSystem
    ;

  darwinHosts = {
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
        inputs.disko.nixosModules.disko
        ./dahlia/nixos.nix
        {
          system.stateVersion = "25.05";
        }
      ];
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
