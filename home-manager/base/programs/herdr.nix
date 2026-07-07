{
  lib,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.herdr ];

  # `herdr --remote <host>` は ssh 非対話 shell で `command -v herdr` を
  # 走らせるが、Linux の envExtra PATH には /etc/profiles/per-user/$USER/bin
  # が含まれず見つからない。~/.local/bin に nix-store の herdr を symlink
  # して、herdr 本体が想定する remote 配置位置に Nix 管理バイナリを露出する。
  # `herdr update` での自動更新は不可 — flake update で 0.5.x を上げる。
  home.file = lib.optionalAttrs pkgs.stdenv.isLinux {
    ".local/bin/herdr".source = "${pkgs.herdr}/bin/herdr";
  };

  # tmux (home-manager/base/programs/tmux.nix) の prefix/操作感に合わせたキーバインド。
  # prefix: tmux は shortcut = "t" なので ctrl+t に統一。
  # split_vertical/split_horizontal は「区切り線の向き」基準の命名（tmuxの-h/-vとは逆の視点）。
  # 実際の見た目は tmux と同じキーになるよう split_vertical=| (左右分割), split_horizontal=- (上下分割) を割当。
  xdg.configFile."herdr/config.toml".text = ''
    onboarding = false

    [ui]
    show_agent_labels_on_pane_borders = false

    [theme]
    name = "tokyo-night"

    # キーは prefix 押下後に入力する単独キーとして書く（"prefix+" を付けると invalid になる）
    [keys]
    prefix = "ctrl+t"

    focus_pane_left = "h"
    focus_pane_down = "j"
    focus_pane_up = "k"
    focus_pane_right = "l"

    split_vertical = "|"    # 左右分割 (tmux: bind | split-window -h)
    split_horizontal = "-"  # 上下分割 (tmux: bind - split-window -v)

    close_pane = "x"
    new_tab = "c"
    new_workspace = "ctrl+n" # デフォルトの n は next_tab に譲る
    previous_tab = "p"
    next_tab = "n"
    detach = "d"
    zoom = "z"
  '';
}
