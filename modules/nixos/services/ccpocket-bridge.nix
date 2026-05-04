{
  config,
  pkgs,
  username,
  ...
}:
let
  ccpocketGitSsh = pkgs.writeShellScript "ccpocket-git-ssh" ''
    set -eu

    state="$HOME/.keychain/$(hostname)-sh"
    if [ -r "$state" ]; then
      . "$state"
    fi

    if [ -z "''${SSH_AUTH_SOCK:-}" ] || [ ! -S "$SSH_AUTH_SOCK" ]; then
      echo "ccpocket-bridge: keychain agent unavailable" >&2
      exit 1
    fi

    exec ${pkgs.openssh}/bin/ssh \
      -o IdentityAgent=SSH_AUTH_SOCK \
      -o IdentitiesOnly=yes \
      "$@"
  '';
in
{
  sops = {
    secrets.anthropic_api_key = {
      sopsFile = ../../../secrets/common.yaml;
    };
    secrets.ccpocket_bridge_api_key = {
      sopsFile = ../../../secrets/common.yaml;
    };
    templates."ccpocket-bridge-env" = {
      content = ''
        ANTHROPIC_API_KEY=${config.sops.placeholder.anthropic_api_key}
        BRIDGE_API_KEY=${config.sops.placeholder.ccpocket_bridge_api_key}
      '';
      owner = username;
    };
  };

  systemd.services.ccpocket-bridge = {
    description = "CC Pocket Bridge Server";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      User = username;
      ExecStart = "${pkgs.ccpocket-bridge}/bin/ccpocket-bridge";
      Restart = "on-failure";
      RestartSec = 10;
      EnvironmentFile = config.sops.templates."ccpocket-bridge-env".path;
      Environment = [
        "HOME=/home/${username}"
        "PATH=/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin"
        "GIT_SSH_COMMAND=${ccpocketGitSsh}"
      ];
    };
  };
}
