{ pkgs, ... }: {
  imports = [ ];

  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # enable required by nix-darwin
  # error: The daemon is not enabled but this is a multi-user install, aborting activation
  services.nix-daemon.enable = true;

  nix.settings.trusted-users = [ "tnmt" ];

  fonts = {
    fontDir.enable = true;

    # nixos use fonts.packages but nix-darwin use fonts.fonts
    # so, currently allow duplication definition
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];
  };

  time.timeZone = "Asia/Tokyo";
}
