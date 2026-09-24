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
  home.activation.rtkCodexInit = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.rtk}/bin/rtk init -g --codex < /dev/null
  '';
}
