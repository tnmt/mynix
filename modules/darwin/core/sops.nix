{ inputs, ... }:
{
  imports = [
    inputs.sops-nix.darwinModules.sops
    ../../common/sops.nix
  ];
}
