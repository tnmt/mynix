{
  pkgs,
  ...
}: {
  home.packages = [pkgs.swaylock-effects];
  home.file.".config/swaylock/config".text = ''
    ignore-empty-password

    font=Noto Sans CJK JP
    font-size=50
    indicator-idle-visible
    indicator-thickness=15
    indicator-radius=150

    inside-color=00000000
    inside-clear-color=00000000
    inside-ver-color=00000000
    inside-wrong-color=00000000
    key-hl-color=#828bb8
    bs-hl-color=#86e1fc

    layout-bg-color=00000000
    layout-border-color=00000000
    layout-text-color=#c8d3f5

    line-color=00000000
    line-clear-color=00000000
    line-ver-color=00000000
    line-wrong-color=00000000

    ring-color=#c8d3f5
    ring-clear-color=#86e1fc
    ring-ver-color=#828bb8
    ring-wrong-color=#ff757f

    separator-color=00000000
    text-color=#c8d3f5
    text-clear-color=#86e1fc
    text-ver-color=#c8d3f5
    text-wrong-color=#ff757f

    effect-blur=5x5
    clock
    timestr=%H:%M:%S
    datestr=%a, %b %d
  '';
}
