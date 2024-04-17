{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  time.timeZone = "Asia/Tokyo";
}
