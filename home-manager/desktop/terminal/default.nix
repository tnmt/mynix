{ pkgs, ... }:
let
  fonts = import ../fonts.nix;
  terminal = {
    # Default terminal emulator, referenced by hyprland/walker configs.
    default = "ghostty";
    font = {
      name = fonts.monospace;
      size = if pkgs.stdenv.isDarwin then 16 else 13;
    };
  };
in
{
  _module.args = { inherit terminal; };

  imports = [
    ./alacritty
    ./ghostty
    ./kitty
    ./foot
  ];
}
