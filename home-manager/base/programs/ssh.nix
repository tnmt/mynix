{ lib, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "1password" = lib.mkIf pkgs.stdenv.isLinux {
        header = ''Match exec "[ -z \"$DISABLE_1PASSWORD_SSH_AGENT\" ] && [ -z \"$SSH_CONNECTION\" ] && [ -S $HOME/.1password/agent.sock ]"'';
        IdentityAgent = "~/.1password/agent.sock";
      };

      "*" = {
        ControlMaster = "auto";
        ControlPersist = "60m";
        ServerAliveInterval = 60;
        ServerAliveCountMax = 5;
        HashKnownHosts = true;
        ForwardAgent = true;
        User = "tnmt";
        StrictHostKeyChecking = "no";
        AddKeysToAgent = "yes";
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
      };
    };

    includes = [
      "conf.d/work.config"
      "conf.d/private.config"
      "~/.colima/ssh_config"
    ];
  };

  # ssh CLI 用の IdentityAgent 指定に加え、SSH_AUTH_SOCK 環境変数自体も
  # 1Password agent に向ける。ssh-keygen -Y sign (git commit の SSH 署名)
  # は IdentityAgent を見ず SSH_AUTH_SOCK を honor するため、これを設定しないと
  # 通常シェルからの署名付き commit が Apple 既定 agent (identity 空) で hang する。
  # Linux は hyprland 側の env 設定で対応しているのでここでは darwin のみ。
  home.sessionVariables = lib.mkIf pkgs.stdenv.isDarwin {
    SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
  };
}
