{ pkgs
, ...
}: {
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "60m";
    serverAliveInterval = 60;
    serverAliveCountMax = 5;
    hashKnownHosts = true;
    forwardAgent = true;
    extraConfig= ''
            User tnmt
            StrictHostKeyChecking no
            AddKeysToAgent yes
          '';

    includes = [
      "conf.d/work.config"
      "conf.d/private.config"
      "~/.colima/ssh_config"
    ];
  };
}
