{ lib, ... }:
{
  # SSH を多用するホスト向けの共通 keychain 設定。
  programs.keychain = {
    enable = true;
    keys = [ "id_ed25519" ];
    extraFlags = [ "--quiet" ];
  };

  # SSH ログイン時は interactive shell に入る前に既存 state を読む。
  # これで ~/.config/zsh/.zshrc を経由しない経路でも local ssh-agent に接続できる。
  programs.zsh.envExtra = lib.mkAfter ''
    if [ -n "$SSH_CONNECTION" ]; then
      _keychain_state="$HOME/.keychain/$(hostname)-sh"
      if [ -r "$_keychain_state" ]; then
        . "$_keychain_state"
        if [ -n "$SSH_AUTH_SOCK" ] && [ ! -S "$SSH_AUTH_SOCK" ]; then
          unset SSH_AUTH_SOCK SSH_AGENT_PID
          rm -f \
            "$HOME/.keychain/$(hostname)-sh" \
            "$HOME/.keychain/$(hostname)-csh" \
            "$HOME/.keychain/$(hostname)-fish"
        fi
      fi
      unset _keychain_state
    fi
  '';
}
