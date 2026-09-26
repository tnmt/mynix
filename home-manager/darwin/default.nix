{ pkgs, ... }:
let
  vncDahlia = pkgs.writeShellApplication {
    name = "vnc-dahlia";
    text = builtins.readFile ./scripts/vnc-dahlia;
  };
in
{
  home.packages = [ vncDahlia ];

  # Karabiner: auto-disable IME when pressing tmux prefix (Ctrl+t) in Alacritty
  xdg.configFile."karabiner/assets/complex_modifications/alacritty_tmux_ime.json".source =
    ./karabiner/alacritty_tmux_ime.json;
}
