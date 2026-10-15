{ config, ... }:
let
  stagentBin = "${config.home.homeDirectory}/.ssh-term/agent/bin/stagent";
in
{
  # SSH Term アプリの Agent Mode 用シェルラッパー。
  # stagent 本体は ~/.ssh-term/agent にアプリが imperative に配置・更新する。
  # `stagent integrate --shell-wrapper` は rc ファイルへの追記を試みるが、
  # .zshrc は Nix store への symlink で書き込めないため同じ内容をここで生成する。
  # アプリはブロック全体の完全一致で設定済みを判定するため、コメント行も含め
  # `stagent integrate --plan --shell-wrapper` の出力と一字一句揃える必要がある。
  # stagent 未導入ホストでは -x チェックで素の command 実行に落ちる。
  programs.zsh.initContent = ''
    # >>> ssh-term stagent >>>
    # Added by SSH Term (stagent integrate --shell-wrapper): runs claude, codex
    # and omp under a stagent PTY holder so SSH Term's Agent Mode can see them.
    # Remove with: stagent integrate --apply --remove shell-wrapper
    export STAGENT_SHELL_WRAPPER=1
    # Non-interactive runs (claude -p, codex exec, omp -p / --mode json) are
    # left alone.
    __stagent_batch() {
      local __stagent_c="$1" __stagent_a __stagent_mode=
      shift
      if [ "$__stagent_c" = codex ]; then
        case ''${1-} in exec|e) return 0 ;; esac
        return 1
      fi
      for __stagent_a in "$@"; do
        if [ -n "$__stagent_mode" ]; then
          [ "$__stagent_a" != text ] && return 0
          __stagent_mode=
          continue
        fi
        case $__stagent_a in
          -p|--print) return 0 ;;
          --mode) [ "$__stagent_c" = omp ] && __stagent_mode=1 ;;
          --mode=*) [ "$__stagent_c" = omp ] && [ "$__stagent_a" != --mode=text ] && return 0 ;;
        esac
      done
      return 1
    }
    __stagent_wrap() {
      local __stagent_bin='${stagentBin}'
      case $- in
        *i*) ;;
        *) command "$@"; return ;;
      esac
      # The passthrough holder needs a terminal on stdin and stdout.
      if [ -t 0 ] && [ -t 1 ] && [ -z "''${STAGENT_SESSION_ID:-}" ] && [ -x "$__stagent_bin" ] && ! __stagent_batch "$@"; then
        "$__stagent_bin" run --handoff=auto -- "$@"
      else
        command "$@"
      fi
    }
    function claude { __stagent_wrap claude "$@"; }
    function codex { __stagent_wrap codex "$@"; }
    function omp { __stagent_wrap omp "$@"; }
    # <<< ssh-term stagent <<<
  '';
}
