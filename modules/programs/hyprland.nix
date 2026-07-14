{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Hyprland's cache so its packages don't rebuild locally. Lives here
  # (not in core) so only hosts that enable Hyprland trust it.
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
