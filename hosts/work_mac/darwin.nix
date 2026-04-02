{ pkgs, inputs, username, ... }:
let
  pkgs-unstable = import inputs.nixpkgs { system = "aarch64-darwin"; };
in
{
  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs-unstable.nixVersions.latest;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  fonts = {
    packages = with pkgs; [
      meslo-lgs-nf
      nerd-fonts.fira-code
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
      "consul-template"
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
      "1password-cli"
      "alacritty"
      "amazon-bedrock-client"
      "chromedriver"
      "firefox"
      "gcloud-cli"
      "google-chrome"
      "goreleaser"
      "visual-studio-code"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "none";
    };
  };

  system.primaryUser = username;
  system.stateVersion = 6;
}
