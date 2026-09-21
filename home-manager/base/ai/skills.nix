# Agent Skill の配置。
#
# 共通配置先は ~/.agents/skills/<name>。まだ ~/.agents を読まない agent には
# 同じ Nix store path への symlink を agent 固有ディレクトリにも張る。
# 実体は store 上に 1 つだけなので、skill の複製管理にはならない。
#
# ここに置くのはグローバルに常用する skill のみ。プロジェクト固有の skill は
# 各 repository の .agents/skills で管理し、この module には入れない。
{
  inputs,
  lib,
  ...
}:
let
  skills = {
    ax = "${inputs.ax}/skills/ax";
    typesafe-ai = "${inputs.typesafe-skills}/skills/typesafe-ai";
  };

  # ~/.agents/skills を直接読まない agent 用のエントリポイント。
  agentSkillDirs = [ ".claude/skills" ];

  mkLinks =
    dir: lib.mapAttrs' (name: src: lib.nameValuePair "${dir}/${name}" { source = src; }) skills;
in
{
  home.file = lib.mkMerge (map mkLinks ([ ".agents/skills" ] ++ agentSkillDirs));
}
