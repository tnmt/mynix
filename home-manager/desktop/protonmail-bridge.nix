{ pkgs, ... }:
{
  # secret-service (gnome-keyring) は system 側の modules/desktop/security.nix
  # で有効化済みなので、その D-Bus 経由で認証情報を保存する。
  # extraPackages は pass を選ぶ場合のフォールバック用 (未初期化。呼ばれると失敗する)。
  services.protonmail-bridge = {
    enable = true;
    package = pkgs.protonmail-bridge;
    logLevel = "info";
    extraPackages = [ pkgs.pass ];
  };

  # graphical-session.target 達成直後は gnome-keyring-daemon (PAM 起動、
  # systemd unit を持たないため target 依存で表現できない) の
  # org.freedesktop.secrets 登録が間に合わないことがある。
  # bridge はこの状態で keychain 読み取りに失敗すると pass にフォールバックし、
  # pass も未初期化で失敗するため vault ごと自動ワイプしてしまう
  # (2026-08-04 に実際に発生、アカウント情報が消失した)。
  # secret-service の準備を待ってから起動することでこのレースを避ける。
  systemd.user.services.protonmail-bridge.Service.ExecStartPre = [
    "${pkgs.writeShellScript "wait-for-secret-service" ''
      for i in $(${pkgs.coreutils}/bin/seq 1 30); do
        if ${pkgs.systemd}/bin/busctl --user status org.freedesktop.secrets >/dev/null 2>&1; then
          exit 0
        fi
        ${pkgs.coreutils}/bin/sleep 1
      done
      echo "secret-service (org.freedesktop.secrets) not ready after 30s; starting bridge anyway" >&2
    ''}"
  ];
}
