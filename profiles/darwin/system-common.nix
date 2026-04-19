# Common macOS system baseline shared by darwin hosts.
{
  pkgs,
  inputs,
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
  system.stateVersion = 6;
}
