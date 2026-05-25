{
  lib,
  osConfig ? null,
  pkgs,
  ...
}:
let
  isWsl = osConfig.wsl.enable or false;
in
{
  # nixpkgs 版 opencode は Bun 製単一バイナリ + autoPatchelf で
  # WSL2 上では起動時に SIGSEGV する。WSL では nixpkgs 版を入れず、
  # 公式インストーラ (curl https://opencode.ai/install) で
  # ~/.opencode/bin に導入したバイナリを nix-ld 経由で実行する。
  home.packages = lib.optionals (!isWsl) [ pkgs.opencode ];
  home.sessionPath = lib.optionals isWsl [ "$HOME/.opencode/bin" ];
}
