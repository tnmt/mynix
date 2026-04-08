{ pkgs, ... }:
let
  fonts = import ../fonts.nix;
  terminal = {
    font = {
      name = fonts.monospace;
      size = if pkgs.stdenv.isDarwin then 16 else 12;
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
