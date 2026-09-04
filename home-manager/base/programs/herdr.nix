{
  lib,
  pkgs,
  ...
}:
{
  # herdr 本体の管理方針:
  # - Nix が管理するのは設定ファイル（下の config.toml）のみ。
  # - Linux ホストの herdr 本体（~/.local/bin/herdr）は imperative 管理。
  #   クライアントの `herdr --remote` 時の自動インストールと `herdr update` で更新される。
  #   過去に ~/.local/bin/herdr を Nix 管理 symlink にしていたが、herdr の
  #   remote install（バージョン不一致時に同パスへ実バイナリを上書き）と取り合いになり
  #   home-manager activation が clobber エラーで壊れるため廃止した（2026-09-04）。
  # - darwin（--remote の起点となるクライアント側）だけ Nix パッケージを入れる。
  #   Linux にも入れると /etc/profiles/per-user/$USER/bin/herdr（Nix 版）と
  #   ~/.local/bin/herdr（imperative 版）が併存しバージョン混乱の元になる。
  home.packages = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ pkgs.herdr ];

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
