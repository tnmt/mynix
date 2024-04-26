{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    home-manager
  ];

  time.timeZone = "Asia/Tokyo";
}
