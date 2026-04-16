# Shared Home Manager profile for darwin development machines.
{ ... }:
{
  imports = [
    ../../home-manager/base
    ../../home-manager/devel
    ../../home-manager/darwin
    ../../home-manager/desktop/terminal
  ];
}
