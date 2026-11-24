# Agent 固有の integration。
#
# RTK は通常の Agent Skill ではなく、agent の hook / instructions を書き換える
# installer を自前で持っている。生成物 ($CODEX_HOME/RTK.md と AGENTS.md の
# RTK ブロック) は rtk のバージョンに紐づく成果物なので、Nix 側にコピーして
# 宣言管理すると rtk を更新するたびに手で追従する二重管理になる。
# そのため Nix が持つのは「どの rtk で init するか」だけにし、生成は pin した
# rtk 自身に任せる。`rtk init -g` (Claude Code) と `rtk init -g --codex` は
# write-if-changed と instructions のブロック upsert なので、activation ごとに
# 再実行しても差分は出ない。rtk を更新すると旧形式の hook は init 時に移行される
# ため、activation で毎回流しておけば「Hook outdated」状態が残らない。
#
# home.file で ~/.claude/{settings.json,CLAUDE.md,RTK.md} や $CODEX_HOME/AGENTS.md
# を管理すると rtk の書き込みと衝突するため、これらのパスは home-manager では
# 管理しないこと。
#
# rtk 1.x の --codex は AGENTS.md / RTK.md に加えて $CODEX_HOME/hooks.json の
# PreToolUse hook (`rtk hook codex`) も upsert する。hooks.json は他ツールの
# hook も同居するため、これも home-manager では管理しない。
#
# stdin を /dev/null にするのは、初回実行時の telemetry 同意プロンプト
# (Enable anonymous telemetry? [y/N]) 対策。stdin が TTY だと入力待ちで
# activation ごと固まる。非 TTY ならプロンプト自体が出ず exit 0 で完走する
# (rtk 0.47.0 で検証済み)。telemetry の同意は各ユーザーが一度 `rtk init` を
# 手動実行して答えれば config.toml に永続化される。
{
  config,
  lib,
  pkgs,
  ...
}:
let
  # rtk の履歴 DB / recall store の置き場所 (Rust の dirs::data_dir 準拠)。
  rtkDataDir =
    if pkgs.stdenv.isDarwin then
      "${config.home.homeDirectory}/Library/Application Support/rtk"
    else
      "${config.xdg.dataHome}/rtk";
in
{
  home = {
    activation = {
      # --auto-patch がないと非 TTY では settings.json への hook 登録が
      # 確認待ちの扱いでスキップされる。
      rtkClaudeInit = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD ${pkgs.rtk}/bin/rtk init -g --auto-patch < /dev/null
      '';

      rtkCodexInit = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD ${pkgs.rtk}/bin/rtk init -g --codex < /dev/null
      '';

      # Codex 自身が trust / plugin / MCP 等の状態を config.toml に追記するため、
      # programs.codex.settings でファイル全体を read-only symlink にはしない。
      # 自律動作に必要な permission 設定だけを宣言的に収束させる。
      # workspace-write sandbox 内で書き換え後の `rtk <cmd>` が履歴 DB を開けず
      # SQLITE_CANTOPEN になるため、rtk の data dir だけ writable_roots に足す。
      # 既存の writable_roots は残し、unique で重複追加を防ぐ。
      codexApprovalDefaults =
        lib.hm.dag.entryAfter
          [
            "rtkCodexInit"
            "writeBoundary"
          ]
          ''
            $DRY_RUN_CMD mkdir -p "$HOME/.codex"
            $DRY_RUN_CMD touch "$HOME/.codex/config.toml"
            $DRY_RUN_CMD env RTK_DATA_DIR=${lib.escapeShellArg rtkDataDir} \
              ${pkgs.yq-go}/bin/yq -p toml -o toml -i \
              '.approval_policy = "on-request" | .approvals_reviewer = "auto_review" | .sandbox_mode = "workspace-write" | .sandbox_workspace_write.writable_roots = ((.sandbox_workspace_write.writable_roots // []) + [strenv(RTK_DATA_DIR)] | unique)' \
              "$HOME/.codex/config.toml"
          '';
    };

    # Plannotator は `plannotator inbox` の起動時に、見つけた agent へ MCP 登録
    # (~/.claude.json、$CODEX_HOME/config.toml 等) と instructions への注記
    # (~/.claude/rules/plannotator-inbox.md 等) を確認なしで書き込む。登録される
    # command は実行中バイナリの絶対パスなので、Nix では /nix/store のパスが
    # agent 設定に残り、plannotator の更新や GC で切れる。どちらも止め、
    # Inbox の MCP は `plannotator` を PATH から引く形で手動登録する
    # (`claude mcp add --scope user plannotator-inbox -- plannotator inbox mcp`)。
    # アプリ内の更新は上流の install.sh で ~/.local/bin に別のバイナリを入れ、
    # Nix 管理の版と二重になるため、更新通知も止める。
    sessionVariables = {
      # Claude Code の Bash ツールは CLAUDE_CODE_SHELL、SHELL の順に、パスに
      # "bash" か "zsh" を含むものを採用する。ログインシェルは zsh のまま
      # 変えず、Claude Code だけ bash にする。
      CLAUDE_CODE_SHELL = lib.getExe pkgs.bashInteractive;
      PLANNOTATOR_INBOX_CONNECT = "0";
      PLANNOTATOR_INBOX_NOTES = "0";
      PLANNOTATOR_UPDATE_CHECK = "0";
    };
  };
}
