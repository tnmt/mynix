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

  system = {
    defaults = {
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
    stateVersion = 6;

    # Workaround: nix-darwin (rev a1fa429) doc/manual/default.nix invokes
    # `nixos-render-docs manual html --toc-depth`, which recent nixpkgs
    # replaced with `--sidebar-depth`, breaking the darwin-manual-html
    # build. Disabling darwin-uninstaller stops its internal eval-config
    # from dragging manualHTML into the system closure; the paired
    # `documentation.doc.enable = false` below drops helpScript /
    # manualHTML from systemPackages. Revert once upstream fixes it.
    tools.darwin-uninstaller.enable = false;
  };

  documentation.doc.enable = false;
}
