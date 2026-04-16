{
  pkgs,
  username,
  ...
}:
{
  systemd.services.ccpocket-bridge = {
    description = "CC Pocket Bridge Server";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      User = username;
      ExecStart = "${pkgs.nodejs_22}/bin/npx @ccpocket/bridge@latest";
      Restart = "on-failure";
      RestartSec = 10;
      Environment = [
        "HOME=/home/${username}"
        "PATH=${pkgs.nodejs_22}/bin:${pkgs.bash}/bin:${pkgs.coreutils}/bin:/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin"
        "npm_config_cache=/home/${username}/.cache/npm"
      ];
    };
  };
}
