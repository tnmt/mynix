{ lib, theme, ... }:
let
  # tig は hex を解釈できないため、テーマの色を xterm 256色の最寄り番号へ丸める
  to256 =
    hex:
    let
      rgb = map (i: lib.fromHexString (builtins.substring i 2 hex)) [
        1
        3
        5
      ];
      cube = [
        0
        95
        135
        175
        215
        255
      ];
      nearest =
        candidates: v:
        lib.foldl' (
          best: c: if abs (c - v) < abs (best - v) then c else best
        ) (builtins.head candidates) candidates;
      abs = n: if n < 0 then -n else n;
      dist =
        a: b:
        lib.foldl'
          (
            s: i:
            s
            +
              (abs (builtins.elemAt a i - builtins.elemAt b i))
              * (abs (builtins.elemAt a i - builtins.elemAt b i))
          )
          0
          [
            0
            1
            2
          ];
      cubeRgb = map (nearest cube) rgb;
      idx = c: lib.lists.findFirstIndex (x: x == c) 0 cube;
      cubeIndex =
        16
        + 36 * idx (builtins.elemAt cubeRgb 0)
        + 6 * idx (builtins.elemAt cubeRgb 1)
        + idx (builtins.elemAt cubeRgb 2);
      avg = (builtins.elemAt rgb 0 + builtins.elemAt rgb 1 + builtins.elemAt rgb 2) / 3;
      grayStep = lib.max 0 (lib.min 23 ((avg - 8 + 5) / 10));
      grayLevel = 8 + 10 * grayStep;
      grayIndex = 232 + grayStep;
    in
    if
      dist rgb [
        grayLevel
        grayLevel
        grayLevel
      ] < dist rgb cubeRgb
    then
      grayIndex
    else
      cubeIndex;
  c = hex: toString (to256 hex);
in
{
  xdg.configFile."tig/config".text = ''
    color cursor ${c theme.foreground} ${c theme.bg_visual} bold
    color cursor-blur ${c theme.foreground} ${c theme.color8}
    color title-focus ${c theme.foreground} ${c theme.bg_visual} bold
    color title-blur ${c theme.color7} ${c theme.bg_highlight}
  '';
}
