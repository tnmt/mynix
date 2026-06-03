{ lib, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "1password" = lib.mkIf pkgs.stdenv.isLinux {
        header = ''Match exec "[ -z \"$SSH_CONNECTION\" ] && [ -S $HOME/.1password/agent.sock ]"'';
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
}
