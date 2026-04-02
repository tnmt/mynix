{
  config,
  lib,
  pkgs,
  ...
}:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    dotDir = "${config.xdg.configHome}/zsh";

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    historySubstringSearch.enable = true;

    history = {
      size = 10000000;
      save = 10000000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
      append = true;
    };

    shellAliases = {
      mv = "mv -i";
      info = "info --vi-keys";
      g = "git";
      be = "bundle exec";
      cat = "bat";
    }
    // lib.optionalAttrs isLinux {
      ls = "eza --color=auto --group-directories-first --time-style=full-iso";
      l = "eza -lah --color=auto --group-directories-first --time-style=full-iso";
    }
    // lib.optionalAttrs isDarwin {
      ls = "eza --color=auto --group-directories-first --time-style=full-iso";
      l = "eza -lah --color=auto --group-directories-first --time-style=full-iso";
    };

    sessionVariables = {
      LANG = "ja_JP.UTF-8";
      LC_TIME = "C";
      GOPATH = "$HOME/.go";
      PAGER = "less";
      LESS = "-R -X";
    };

    envExtra = ''
      export PATH="''${KREW_ROOT:-$HOME/.krew}/bin:$GOPATH/bin:$HOME/.cache/.bun/bin:$HOME/.npm-global/bin:$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/work/bin:/usr/local/bin:/usr/local/sbin:/sbin:/usr/sbin:$PATH"
    ''
    + lib.optionalString isDarwin ''
      export PATH="/opt/homebrew/bin:$PATH"
      export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
    '';

    initContent = ''
      # Shell options
      setopt no_beep rmstar_wait notify hist_verify transient_rprompt no_flow_control
      setopt hist_no_store inc_append_history

      # fzf: git branch checkout (Ctrl+x b)
      function fzf-checkout-git-branch() {
        local branch=$(git branch -a --sort=-committerdate \
          | grep -v 'HEAD' \
          | sed 's/^[* ]*//' \
          | sed 's|^remotes/origin/||' \
          | awk '!seen[$0]++' \
          | fzf --query "$LBUFFER")
        if [ -n "$branch" ]; then
          BUFFER="git checkout ''${branch}"
          zle accept-line
        fi
        zle reset-prompt
      }
      zle -N fzf-checkout-git-branch
      bindkey '^xb' fzf-checkout-git-branch

      # fzf: ghq repository (Ctrl+])
      function fzf-cd-ghq-repository() {
        local dest=$(ghq list -p | fzf --query "$LBUFFER")
        if [ -n "$dest" ]; then
          BUFFER="cd ''${dest}"
          zle accept-line
        fi
        zle reset-prompt
      }
      zle -N fzf-cd-ghq-repository
      bindkey '^]' fzf-cd-ghq-repository

      # Temp dir alias (needs to be a function, not alias, for date eval)
      function td() {
        local d=~/tmp/$(date '+%Y%m%d-%H%M')
        mkdir -p "$d" && cd "$d"
      }

      # 1Password CLI plugin
      [ -f ~/.config/op/plugins.sh ] && source ~/.config/op/plugins.sh

      # 1Password service account (headless)
      if [ -f "$HOME/.config/op/service-account-token" ]; then
        export OP_SERVICE_ACCOUNT_TOKEN="$(cat "$HOME/.config/op/service-account-token")"
      fi

      # Starship transient prompt
      if command -v starship &> /dev/null; then
        zle-line-init() {
          emulate -L zsh
          [[ $CONTEXT == start ]] || return 0

          while true; do
            zle .recursive-edit
            local -i ret=$?
            [[ $ret == 0 && $KEYS == $'\4' ]] || break
            [[ -o ignore_eof ]] || exit 0
          done

          local saved_prompt=$PROMPT
          local saved_rprompt=$RPROMPT
          PROMPT=$'\n❯ '
          RPROMPT=""
          zle .reset-prompt
          PROMPT=$saved_prompt
          RPROMPT=$saved_rprompt

          if (( ret )); then
            zle .send-break
          else
            zle .accept-line
          fi
          return ret
        }
        zle -N zle-line-init
      fi
    ''
    + lib.optionalString isLinux ''

      # Fcitx5 (Japanese input)
      export XMODIFIERS=@im=fcitx
      export INPUT_METHOD=fcitx
    '';
  };
}
