{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  programs.ssh.startAgent = true;

  time.timeZone = "Asia/Tokyo";
}
