{
  config,
  pkgs,
  username,
  ...
}:
{
  # Bundled claude binary inside @anthropic-ai/claude-agent-sdk is a
  # prebuilt glibc ELF that needs /lib64/ld-linux-x86-64.so.2 at runtime.
  programs.nix-ld.enable = true;

  sops.secrets.anthropic_api_key = {
    sopsFile = ../../secrets/common.yaml;
  };
  sops.templates."ccpocket-bridge-env" = {
    content = ''
      ANTHROPIC_API_KEY=${config.sops.placeholder.anthropic_api_key}
    '';
    owner = username;
  };

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
      EnvironmentFile = config.sops.templates."ccpocket-bridge-env".path;
      Environment = [
        "HOME=/home/${username}"
        "PATH=${pkgs.nodejs_22}/bin:${pkgs.bash}/bin:${pkgs.coreutils}/bin:${pkgs.bubblewrap}/bin:/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin"
        "npm_config_cache=/home/${username}/.cache/npm"
      ];
    };
  };
}
