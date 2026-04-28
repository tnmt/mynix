{ pkgs, ... }:
{
  imports = [
    ./fcitx5.nix
    ./fonts.nix
    ./security.nix
    ./sound.nix
  ];

  services = {
    gvfs.enable = true;
    udisks2.enable = true;
    tumbler.enable = true;
  };

  programs = {
    dconf.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-volman
        thunar-archive-plugin
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    ffmpegthumbnailer
    webp-pixbuf-loader
  ];

  xdg.portal = {
    enable = true;
    config.common.default = "*";
  };
}
