{
  lib,
  pkgs,
  terminal,
  theme,
  ...
}:
let
  fonts = import ./fonts.nix;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  # Ghostty の font-size は pt、Herdr UI は論理 px。Linux では同じ数値だと
  # Herdr UI が約 13% 小さくなるため、dahlia の実測（13 → 15）で補正する。
  # Herdr UI は fallback の日本語を等倍で描くので、半角 0.5em・全角 1em の
  # HackGen で 2 セルを全角幅に揃える。半角が Meslo (0.6em) より細い分、
  # さらに 0.6/0.5 倍して 1 セルの幅を Ghostty に合わせる。
  family = if isLinux then "HackGen Console NF" else terminal.font.name;
  sizeScale = if isLinux then 15.0 / 13 * 0.6 / 0.5 else 1.0;
  lineHeight = if isLinux then 1.1 else 1.43;
in
{
  # darwin は herdr-gpui cask（homebrew 側）で入れる。
  home.packages = lib.optionals isLinux [ pkgs.herdr-gpui ];

  # herdr UI は GUI から設定を保存すると config-gpui.local.toml を書き換える。
  # Nix 管理にすると symlink で読み取り専用になるため、GUI 側の変更は反映されない。
  # 変えたい値はここに書くこと。terminal のフォントは Ghostty と揃える。
  xdg.configFile."herdr/config-gpui.local.toml".text = ''
    layout = "comfortable-rounded"
    remove_merged_worktrees = true
    theme = "${theme.herdr-gpui}"

    [terminal]
    family = "${family}"
    size = ${toString (terminal.font.size * sizeScale)}
    line_height = ${toString lineHeight}
    # fallback を指定すると Nerd Font の自動フォールバックは効かなくなるが、
    # 主フォントが Nerd Font 入りなのでアイコンは出る。
    fallback = [ "${fonts.sans}" ]

    # blur は Hyprland のウィンドウ blur に任せる。Herdr UI 側の blur は KDE の
    # blur protocol 経由でしか効かないので指定しない。
    [backdrop]
    opacity = ${toString terminal.background.opacity}

    [remote]
    enabled = true
  '';
}
