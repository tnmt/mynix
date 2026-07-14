{ inputs, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    ../../common/sops.nix
  ];
}
