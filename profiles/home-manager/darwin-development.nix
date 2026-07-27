# Shared Home Manager profile for darwin development machines.
{ ... }:
{
  imports = [
    ../../home-manager/base
    ../../home-manager/devel
    ../../home-manager/darwin
    ../../home-manager/desktop/apps.nix # OS 非依存の個別アプリ (vesktop 等)
    ../../home-manager/desktop/terminal
  ];
}
