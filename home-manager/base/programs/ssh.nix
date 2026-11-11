_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      # git/ssh の agent は全ホストで keychain
      # (profiles/home-manager/ssh-agent-keychain.nix) に一本化し、IdentityAgent は
      # 指定せず SSH_AUTH_SOCK に任せる。1Password agent はセッションのロック中に
      # 署名できず、リモートから操作すると git/ssh がハングまたは失敗する。
      # かつて Linux では `Match exec "... [ -z $SSH_CONNECTION ] ..."` で
      # 1Password agent を選んでいたが、herdr 等ローカル起動のセッションに
      # リモートSSHからアタッチすると SSH_CONNECTION が空のまま「ローカル」と
      # 誤判定されていた。
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
      };
    };

    includes = [
      "conf.d/work.config"
      "conf.d/private.config"
      "~/.colima/ssh_config"
    ];
  };
}
