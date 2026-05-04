# Darwin profile: mo bundle.
# Counterpart of profiles/nixos/mo.nix.
{
  config,
  lib,
  ...
}:
let
  cfg = config.mynix.profiles.mo;
in
{
  imports = [
    ../../modules/darwin/services/local-https-proxy.nix
  ];

  options.mynix.profiles.mo.enable = lib.mkEnableOption "mo + Caddy reverse proxy bundle";

  config = lib.mkIf cfg.enable {
    mynix.services.localHttpsProxy = {
      enable = true;
      virtualHosts."mo.lvh.me".upstream = "127.0.0.1:6275";
    };
  };
}
