{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.mynix.services.t3code;

  # nixpkgs の codex は PATH 先頭に入って、ユーザー環境 (Home Manager) の
  # codex を隠してしまう。CLI は Home Manager 側に一本化する。
  t3code = pkgs.t3code.override { enableCodex = false; };

  # ccpocket-bridge と同じく、systemd 経由では SSH_AUTH_SOCK が無いので
  # keychain の agent を読み込んでから ssh を起動する。
  keychainSsh = pkgs.writeShellApplication {
    name = "ssh";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.openssh
    ];
    text = ''
      state="$HOME/.keychain/$(uname -n)-sh"
      if [ -r "$state" ]; then
        # shellcheck source=/dev/null
        . "$state"
      fi

      if [ -z "''${SSH_AUTH_SOCK:-}" ] || [ ! -S "$SSH_AUTH_SOCK" ]; then
        echo "t3code: keychain agent unavailable" >&2
        exit 1
      fi

      config="$(readlink -f "$HOME/.ssh/config" 2>/dev/null || true)"
      configArgs=()
      if [ -n "$config" ] && [ -r "$config" ]; then
        configArgs=(-F "$config")
      fi

      exec ssh \
        "''${configArgs[@]}" \
        -o IdentityAgent=SSH_AUTH_SOCK \
        -o IdentitiesOnly=yes \
        "$@"
    '';
  };
in
{
  options.mynix.services.t3code = {
    enable = lib.mkEnableOption "T3 Code server";

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "100.67.0.1";
      description = ''
        Address the server binds to. T3 Code serves plain HTTP and relies on a
        pairing token for authentication, so bind to the NetBird address of the
        host instead of 0.0.0.0 to keep LAN peers out.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3773;
      description = "TCP port of the HTTP/WebSocket server.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ t3code ];

    # 認証情報 (pairing で発行した session) は ~/.t3/userdata/secrets に
    # 保存される。Nix store と sops には載せない。
    systemd.services.t3code = {
      description = "T3 Code Server";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = username;
        WorkingDirectory = "/home/${username}";
        ExecStart = lib.escapeShellArgs [
          "${t3code}/bin/t3"
          "serve"
          "--host"
          cfg.host
          "--port"
          (toString cfg.port)
        ];
        # 起動時に pairing token 入りの URL を stdout へ出す。通常ログも同じ
        # stdout に出るため、journald に token を残さないよう stdout ごと捨てる。
        # サーバーのログは ~/.t3/userdata/logs に別途書かれる。
        StandardOutput = "null";
        Restart = "on-failure";
        RestartSec = 10;
        Environment = [
          "HOME=/home/${username}"
          "PATH=${keychainSsh}/bin:/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin"
          "GIT_SSH_COMMAND=${keychainSsh}/bin/ssh"
        ];
      };
    };
  };
}
