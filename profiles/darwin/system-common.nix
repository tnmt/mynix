# Common macOS system baseline shared by darwin hosts.
{
  pkgs,
  inputs,
  ...
}:
let
  pkgsUnstable = import inputs.nixpkgs { system = "aarch64-darwin"; };
in
{
  nix.package = pkgsUnstable.nixVersions.latest;

  fonts = {
    packages = with pkgs; [
      meslo-lgs-nf
      nerd-fonts.fira-code
    ];
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
  system.stateVersion = 6;
}
