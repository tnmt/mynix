# WSL では user systemd が使えないので、kiseki の Home Manager モジュール
# (user timer) の代わりに system service を User=${username} で動かす。
# ブラウザは Windows 側にしかないため Claude Code だけを集める。
# server URL とトークンの置き場所は home-manager/devel/kiseki.nix と同じ。
{
  inputs,
  pkgs,
  username,
  ...
}:
let
  home = "/home/${username}";
  configFile = (pkgs.formats.json { }).generate "kiseki-agent.json" {
    server_file = "${home}/.config/kiseki/server";
    token_file = "${home}/.config/kiseki/token";
    spool_dir = "${home}/.local/state/kiseki";
    timezone = "Asia/Tokyo";
    claude_code = { };
  };
  kiseki = inputs.kiseki.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  systemd.services.kiseki-agent = {
    description = "kiseki agent";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = username;
      Environment = [ "HOME=${home}" ];
      ExecStart = "${pkgs.lib.getExe kiseki} agent -config ${configFile}";
    };
  };

  systemd.timers.kiseki-agent = {
    description = "Run the kiseki agent periodically";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "15min";
      RandomizedDelaySec = "1min";
    };
  };
}
