{ pkgs, ... }:
{
  # secret-service (gnome-keyring) は system 側の modules/desktop/security.nix
  # で有効化済みなので、その D-Bus 経由で認証情報を保存する。
  # extraPackages は pass を選ぶ場合のフォールバック用。
  services.protonmail-bridge = {
    enable = true;
    package = pkgs.protonmail-bridge;
    logLevel = "info";
    extraPackages = [ pkgs.pass ];
  };
}
