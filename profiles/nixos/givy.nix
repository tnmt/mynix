# NixOS profile: givy bundle. Shared options and wiring live in
# profiles/common/givy.nix; this pairs them with the NixOS proxy backend.
{
  imports = [
    ../common/givy.nix
    ../../modules/nixos/services/local-https-proxy.nix
  ];
}
