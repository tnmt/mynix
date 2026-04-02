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
    taps = [
      "hashicorp/tap"
      "k1LoW/tap"
      "pyama86/kagiana"
      "takai/tap"
    ];
    brews = [
      "colima"
      "consul"
      "docker"
      "envchain"
      "gogcli"
      "hashicorp/tap/vault"
      "k1low/tap/mo"
      "pyama86/kagiana/kagiana"
      "takai/tap/git-ai-commit"
      "the_platinum_searcher"
    ];
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
