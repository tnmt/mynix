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
  # `herdr update` での自動更新は不可 — nixpkgs 由来なので flake update で上げる。
  home.file = lib.optionalAttrs pkgs.stdenv.isLinux {
    ".local/bin/herdr".source = "${pkgs.herdr}/bin/herdr";
  };

  # tmux (home-manager/base/programs/tmux.nix) の prefix/操作感に合わせたキーバインド。
  # prefix: tmux は shortcut = "t" なので ctrl+t に統一。
  # キー表記は herdr 0.6+ の仕様: "prefix+n" = prefix を押してから n。
  # 裸の "n" は direct binding（グローバル）になりタイピングを奪うので使わないこと。
  # split_vertical/split_horizontal は「区切り線の向き」基準の命名（tmuxの-h/-vとは逆の視点）。
  # 実際の見た目は tmux と同じキーになるよう split_vertical=| (左右分割), split_horizontal=- (上下分割) を割当。
  xdg.configFile."herdr/config.toml".text = ''
    onboarding = false

    [ui]
    show_agent_labels_on_pane_borders = false

    [theme]
    name = "tokyo-night"

    [keys]
    prefix = "ctrl+t"

    focus_pane_left = "prefix+h"
    focus_pane_down = "prefix+j"
    focus_pane_up = "prefix+k"
    focus_pane_right = "prefix+l"

    split_vertical = "prefix+|"       # 左右分割 (tmux: bind | split-window -h)
    split_horizontal = "prefix+minus" # 上下分割 (tmux: bind - split-window -v)

    close_pane = "prefix+x"
    new_tab = "prefix+c"
    previous_tab = "prefix+p"
    next_tab = "prefix+n"
    detach = "prefix+d"               # default: prefix+q
    zoom = "prefix+z"
  '';
}
