{ pkgs, ... }:
{
  imports = [
    ./fcitx5.nix
    ./fonts.nix
    ./security.nix
    ./sound.nix
  ];

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  programs = {
    dconf.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-volman
      ];
    };
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
  };
}
