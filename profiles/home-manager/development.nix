# Shared Home Manager baseline for NixOS development machines.
{ ... }:
{
  imports = [
    ../../home-manager/base-nixos
    ../../home-manager/devel
  ];
}
