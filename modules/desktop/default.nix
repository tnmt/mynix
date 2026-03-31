{
  imports = [
    ./fcitx5.nix
    ./fonts.nix
    ./security.nix
    ./sound.nix
  ];

  programs = {
    dconf.enable = true;
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
  };
}
