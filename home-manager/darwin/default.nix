{ pkgs, ... }:
{
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  # Karabiner: auto-disable IME when pressing tmux prefix (Ctrl+t) in Alacritty
  xdg.configFile."karabiner/assets/complex_modifications/alacritty_tmux_ime.json".source =
    ./karabiner/alacritty_tmux_ime.json;
}
