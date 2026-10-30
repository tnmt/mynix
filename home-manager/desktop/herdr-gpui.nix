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
  # Herdr UI は fallback の日本語を等倍で描くので、Linux では半角 0.5em・
  # 全角 1em の HackGen を使い、2 セルを全角幅に揃える。
  # font-size は Ghostty が pt、Herdr UI が論理 px で、HackGen の半角は
  # Meslo (0.6em) より細い。dahlia で読みやすい大きさを実測して係数にしている。
  family = if isLinux then "HackGen Console NF" else terminal.font.name;
  sizeScale = if isLinux then 1.5 else 1.0;
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
    # 淡い補助文字（ブランチ名など）を背景から 4.5:1 まで離す。
    contrast = "high"

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
  ''
  # 既定の DejaVu 系・12 だと小さく、日本語を含むタブ名やサイドバーが読みにくい。
  # Noto Sans CJK JP の Regular は細くて薄く見えたので、端末と同じ HackGen にする。
  # darwin は既定の .SystemUIFont が読めるので指定しない。
  + lib.optionalString isLinux ''

    [ui]
    family = "${family}"
    size = 16

    [tabs]
    family = "${family}"
    size = 16

    [sidebar]
    family = "${family}"
    size = 16
  '';
}
