{
  ...
}:
{
  imports = [
    ../../profiles/home-manager/wsl.nix
    ../../profiles/home-manager/ssh-agent-keychain.nix
    ../../home-manager/devel/kiseki.nix
  ];

  # ブラウザは Windows 側にしかないので Claude Code だけを集める。
  services.kiseki-agent.browserHistory.enable = false;
}
