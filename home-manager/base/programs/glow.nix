{ pkgs, ... }:
{
  home.packages = [ pkgs.glow ];

  xdg.configFile."glow/glow.yml".text = ''
    style: "auto"
    mouse: false
    pager: true
    width: 80
    all: false
  '';
}
