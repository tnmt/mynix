{ lib, ... }:
{
  imports = [
    ./development.nix
  ];

  # WSL has no user systemd; secrets are managed at the NixOS system level.
  sops.secrets = lib.mkForce { };
  sops.templates = lib.mkForce { };
}
