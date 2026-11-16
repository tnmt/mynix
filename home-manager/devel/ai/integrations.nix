# Agent 固有の integration。
#
# RTK は通常の Agent Skill ではなく、agent の hook / instructions を書き換える
# installer を自前で持っている。生成物 ($CODEX_HOME/RTK.md と AGENTS.md の
# RTK ブロック) は rtk のバージョンに紐づく成果物なので、Nix 側にコピーして
# 宣言管理すると rtk を更新するたびに手で追従する二重管理になる。
# そのため Nix が持つのは「どの rtk で init するか」だけにし、生成は pin した
# rtk 自身に任せる。`rtk init -g --codex` は write-if-changed と
# AGENTS.md のブロック upsert なので、activation ごとに再実行しても差分は出ない。
#
# home.file で $CODEX_HOME/AGENTS.md を管理すると rtk の書き込みと衝突するため、
# これらのパスは home-manager では管理しないこと。
#
# 注意: rtk 0.47.0 (nixpkgs) の --codex は AGENTS.md + RTK.md のみを生成する。
# Codex の PreToolUse hook ($CODEX_HOME/hooks.json / `rtk hook codex`) は
# この版には存在しない。
#
# stdin を /dev/null にするのは、初回実行時の telemetry 同意プロンプト
# (Enable anonymous telemetry? [y/N]) 対策。stdin が TTY だと入力待ちで
# activation ごと固まる。非 TTY ならプロンプト自体が出ず exit 0 で完走する
# (rtk 0.47.0 で検証済み)。telemetry の同意は各ユーザーが一度 `rtk init` を
# 手動実行して答えれば config.toml に永続化される。
{ lib, pkgs, ... }:
{
  home = {
    activation = {
      rtkCodexInit = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD ${pkgs.rtk}/bin/rtk init -g --codex < /dev/null
      '';

      # Codex 自身が trust / plugin / MCP 等の状態を config.toml に追記するため、
      # programs.codex.settings でファイル全体を read-only symlink にはしない。
      # 自律動作に必要な permission 設定だけを宣言的に収束させる。
      codexApprovalDefaults =
        lib.hm.dag.entryAfter
          [
            "rtkCodexInit"
            "writeBoundary"
          ]
          ''
            $DRY_RUN_CMD mkdir -p "$HOME/.codex"
            $DRY_RUN_CMD touch "$HOME/.codex/config.toml"
            $DRY_RUN_CMD ${pkgs.yq-go}/bin/yq -p toml -o toml -i \
              '.approval_policy = "on-request" | .approvals_reviewer = "auto_review" | .sandbox_mode = "workspace-write"' \
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
      PLANNOTATOR_INBOX_CONNECT = "0";
      PLANNOTATOR_INBOX_NOTES = "0";
      PLANNOTATOR_UPDATE_CHECK = "0";
    };
  };
}
