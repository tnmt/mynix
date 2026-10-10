# kiseki ライフログの agent。ホストごとにトークンが要るので devel には
# 含めず、トークンを発行したホストだけが import する。user systemd が
# 使えない WSL では modules/nixos/services/kiseki-agent.nix を使う。
# server URL は mesh 内のホスト名なので、system layer の sops から
# ~/.config/kiseki/server に置いたもの (mynix.profiles.userTemplates.kiseki)
# を読ませる。トークンは `kiseki token new` の出力を手で
# ~/.config/kiseki/token (0600) に保存する。
{ config, inputs, ... }:
{
  imports = [ inputs.kiseki.homeManagerModules.kiseki-agent ];

  programs.kiseki-agent = {
    enable = true;
    serverFile = "${config.xdg.configHome}/kiseki/server";
    tokenFile = "${config.xdg.configHome}/kiseki/token";
    claudeCode.enable = true;
  };
}
