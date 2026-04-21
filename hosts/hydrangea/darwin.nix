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

  # Authorize work_mac so it can ssh in (matches the prior manual
  # ~/.ssh/authorized_keys setup). To be replaced by hosts.work_mac
  # once work_mac gets its own per-host ed25519.
  users.users."${username}".openssh.authorizedKeys.keys = with pubkeys; [
    legacy.workmac_rsa
  ];

  # Host-specific Home Manager entrypoint.
  home-manager.users."${username}" = import ./home-manager.nix;
}
