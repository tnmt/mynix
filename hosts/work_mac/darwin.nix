{ pkgs, username, ... }:
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

  homebrew = {
    enable = true;
    casks = [
      "alacritty"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "none";
    };
  };

  system.primaryUser = username;
  system.stateVersion = 6;
}
