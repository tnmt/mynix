{ username, ... }:
let
  pubkeys = import ../../modules/common/ssh-pubkeys.nix;
in
{
  imports = [
    ../../modules/darwin/core

    # Shared macOS base configuration.
    ../../profiles/darwin/system-common.nix
    ../../profiles/darwin/homebrew-base.nix
  ];

  # Bring the system sshd under nix-darwin so Remote Login stays on
  # and the authorizedKeysCommand drop-in at
  # /etc/ssh/sshd_config.d/101-authorized-keys.conf is installed.
  services.openssh.enable = true;

  # Authorize work_mac so it can ssh in.
  users.users."${username}".openssh.authorizedKeys.keys = with pubkeys; [
    hosts.work_mac
  ];

  mynix.profiles.userTemplates = {
    enable = true;
    sshPrivate = {
      role = "client";
      tier = "laptop";
    };
  };

  # Host-specific Home Manager entrypoint.
  home-manager.users."${username}" = import ./home-manager.nix;
}
