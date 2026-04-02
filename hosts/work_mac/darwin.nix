{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  fonts = {
    packages = with pkgs; [
      meslo-lgs-nf
    ];
  };

  environment.systemPackages = with pkgs; [
    home-manager
  ];

  system.stateVersion = 6;
}
