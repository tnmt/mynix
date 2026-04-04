{
  pkgs,
  inputs,
  username,
  ...
}:
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
      "k1LoW/tap"
      "takai/tap"
    ];
    brews = [
      "gogcli"
      "k1low/tap/mo"
      "takai/tap/git-ai-commit"
    ];
    casks = [
      "1password-cli"
      "appcleaner"
      "brave-browser"
      "chatgpt"
      "choosy"
      "claude"
      "discord"
      "dropbox"
      "firefox"
      "ghostty"
      "google-chrome"
      "iterm2"
      "karabiner-elements"
      "obsidian"
      "raycast"
      "slack"
      "vimr"
      "zoom"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
    };
  };

  system.defaults = {
    dock = {
      autohide = true;
    };

    finder = {
      FXPreferredViewStyle = "icnv";
    };

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      InitialKeyRepeat = 30;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
    };

    # Hot corners: bottom-left = Lock Screen, bottom-right = Quick Note
    dock.wvous-bl-corner = 13;
    dock.wvous-br-corner = 14;
  };

  system.primaryUser = username;
  system.stateVersion = 6;
}
