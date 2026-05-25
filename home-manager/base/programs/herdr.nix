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
}
