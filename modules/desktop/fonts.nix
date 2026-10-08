{ pkgs, ... }:
let
  fonts = import ../../home-manager/desktop/fonts.nix;
in
{
  fonts = {
    packages = with pkgs; [
      meslo-lgs-nf
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
    ];
    fontDir.enable = true;
    fontconfig = {
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
      defaultFonts = {
        serif = [
          "Noto Serif CJK JP"
          fonts.emoji
        ];
        sansSerif = [
          fonts.sans
          fonts.emoji
        ];
        monospace = [
          fonts.monospace
          fonts.sans
          fonts.emoji
        ];
        emoji = [ fonts.emoji ];
      };
    };
  };
}
