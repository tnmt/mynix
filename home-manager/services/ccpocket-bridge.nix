{
  pkgs,
  username,
  ...
}:
{
  systemd.user.services.ccpocket-bridge = {
    Unit.Description = "CC Pocket Bridge Server";
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.nodejs_22}/bin/npx @ccpocket/bridge@latest";
      Restart = "on-failure";
      RestartSec = 10;
      WorkingDirectory = "%h";
      Environment = [
        "HOME=%h"
        "PATH=${pkgs.nodejs_22}/bin:${pkgs.bash}/bin:${pkgs.coreutils}/bin:%h/.nix-profile/bin:/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin"
        "npm_config_cache=%h/.cache/npm"
      ];
    };
    Install.WantedBy = [ "default.target" ];
  };
}
