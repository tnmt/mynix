{ ... }:
{
  # OS 非依存の個別アプリ設定。darwin / Linux 双方のプロファイルから import する。
  # ここに置くモジュールは nixpkgs が aarch64-darwin をサポートするものに限る
  # (vesktop, yazi は meta.platforms に aarch64-darwin を含むことを確認済み)。
  imports = [
    ./vesktop.nix
    ./yazi.nix
  ];
}
