{ pkgs, ... }:
let
  fonts = import ../fonts.nix;
  terminal = {
    # Default terminal emulator, referenced by hyprland configs.
    default = "ghostty";
    font = {
      name = fonts.monospace;
      size = if pkgs.stdenv.hostPlatform.isDarwin then 16 else 13;
    };
    # Ghostty と Herdr UI で背景の透け具合を揃える。
    background = {
      opacity = 0.95;
      blur = 20;
    };
  };
in
{
  _module.args = { inherit terminal; };

  imports = [
    ./ghostty
    ./foot
  ];
}
