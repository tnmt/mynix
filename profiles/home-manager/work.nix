# Home Manager profile for work NixOS environments.
{ ... }:
{
  imports = [
    ../../home-manager/base-nixos
    ../../home-manager/devel
    ../../home-manager/work
  ];
}
