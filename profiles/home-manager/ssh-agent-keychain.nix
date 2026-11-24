{ config, lib, ... }:
let
  cfg = config.programs.keychain;
  keychainEval = "${lib.getExe cfg.package} --eval ${lib.concatStringsSep " " cfg.extraFlags} ${lib.concatStringsSep " " cfg.keys}";
in
{
  programs = {
    # SSH を多用するホスト向けの共通 keychain 設定。
    keychain = {
      enable = true;
      keys = [ "id_ed25519" ];
      extraFlags = [ "--quiet" ];
      # 標準の zsh 連携は起動のたびに keychain を実行し、約120ms かかる。
      # state ファイルの agent が生きていて鍵も載っていれば keychain を呼ばない。
      enableZshIntegration = false;
    };

    zsh = {
      initContent = ''
        _keychain_state="$HOME/.keychain/$(hostname)-sh"
        [ -r "$_keychain_state" ] && . "$_keychain_state"
        unset _keychain_state
        if ! ssh-add -l >/dev/null 2>&1; then
          eval "$(SHELL=zsh ${keychainEval})"
        fi
      '';

      # SSH ログイン時は interactive shell に入る前に既存 state を読む。
      # これで ~/.config/zsh/.zshrc を経由しない経路でも local ssh-agent に接続できる。
      envExtra = lib.mkAfter ''
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
    };
  };
}
