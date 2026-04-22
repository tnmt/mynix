{ username, ... }:
let
  pubkeys = import ../../modules/common/ssh-pubkeys.nix;
in
{
  imports = [
    ../../profiles/nixos/openstack.nix
  ];

  # Receive-only node: no private key here. Authorize work_mac so it
  # can ssh in.
  users.users."${username}".openssh.authorizedKeys.keys = with pubkeys; [
    hosts.work_mac
  ];

  home-manager.users."${username}" = import ./home-manager.nix;
}
