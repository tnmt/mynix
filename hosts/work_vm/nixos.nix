{ username, ... }:
let
  pubkeys = import ../../modules/common/ssh-pubkeys.nix;
in
{
  imports = [
    ../../profiles/nixos/openstack.nix
    ../../modules/nixos/core
  ];

  # Receive-only node: no private key here. Authorize work_mac's RSA
  # so it can ssh in. To be replaced by hosts.work_mac (new ed25519)
  # once work_mac generates its per-host key.
  users.users."${username}".openssh.authorizedKeys.keys = with pubkeys; [
    legacy.workmac_rsa
  ];

  home-manager.users."${username}" = import ./home-manager.nix;
}
