# AI coding agent 周りを 4 レイヤーに分けて管理する。
#   packages.nix     … CLI 本体 (agent 非依存)
#   skills.nix       … Agent Skill の配置 (agent 非依存 + agent 別 symlink)
#   integrations.nix … agent 固有の hook / instructions 生成
#   secrets.nix      … skill から分離した API key の受け渡し
{ ... }:
{
  imports = [
    ./integrations.nix
    ./packages.nix
    ./secrets.nix
    ./skills.nix
  ];
}
