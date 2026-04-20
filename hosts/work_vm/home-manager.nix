# Home Manager entrypoint for the work OpenStack dev VM.
# Age keys are not provisioned on this host yet, so sops secrets are disabled.
{ lib, ... }:
{
  imports = [
    ../../profiles/home-manager/development.nix
  ];

  sops.secrets = lib.mkForce { };
  sops.templates = lib.mkForce { };
}
