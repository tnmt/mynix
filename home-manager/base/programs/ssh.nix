{ lib, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks."*" = {
      controlMaster = "auto";
      controlPersist = "60m";
      serverAliveInterval = 60;
      serverAliveCountMax = 5;
      hashKnownHosts = true;
      forwardAgent = true;
      user = "tnmt";
      extraOptions = {
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
