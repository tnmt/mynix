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

  username = "tnmt";

  darwinHosts = {
    hydrangea = {
      system = "aarch64-darwin";
      inherit username;
      modules = [ ./hydrangea ];
    };
  };

  nixosHosts = {
    sunflower = {
      system = "x86_64-linux";
      inherit username;
      modules = [ ./sunflower ];
    };
    dahlia = {
      system = "x86_64-linux";
      inherit username;
      modules = [
        inputs.disko.nixosModules.disko
        ./dahlia
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
