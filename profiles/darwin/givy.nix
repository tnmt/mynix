# Darwin profile: givy bundle. Shared options and wiring live in
# profiles/common/givy.nix; this pairs them with the launchd proxy backend.
{
  imports = [
    ../common/givy.nix
    ../../modules/darwin/services/local-https-proxy.nix
  ];
}
