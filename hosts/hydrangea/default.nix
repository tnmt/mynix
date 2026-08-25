{ username, ... }:
let
  pubkeys = import ../../modules/common/ssh-pubkeys.nix;
in
{
  imports = [
    ../../modules/darwin/core

    ../../profiles/darwin/system-common.nix
    ../../profiles/darwin/homebrew-base.nix
  ];

  # Bring the system sshd under nix-darwin so Remote Login stays on
  # and the authorizedKeysCommand drop-in at
  # /etc/ssh/sshd_config.d/101-authorized-keys.conf is installed.
  services.openssh.enable = true;

  users.users."${username}".openssh.authorizedKeys.keys = with pubkeys; [
    hosts.work_mac
  ];

  mynix.profiles.userTemplates = {
    enable = true;
    sshPrivate = {
      role = "client";
      tier = "laptop";
    };
    tnmtInfo = true;
  };

  home-manager.users."${username}" = import ./home-manager.nix;
}
