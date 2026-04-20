{ username, ... }:
{
  imports = [
    ../../profiles/nixos/openstack.nix
    ../../modules/nixos/core
  ];

  home-manager.users."${username}" = import ./home-manager.nix;
}
