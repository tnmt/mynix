# NixOS profile: mo bundle.
# Front the user-launched `mo` Markdown viewer (port 6275) at
# https://mo.lvh.me via Caddy. Trust setup is host-local; combine with
# `mynix.services.localHttpsProxy.trustedRootCAFile` if needed.
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
    ../../modules/nixos/services/local-https-proxy.nix
  ];

  options.mynix.profiles.mo.enable = lib.mkEnableOption "mo + Caddy reverse proxy bundle";

  config = lib.mkIf cfg.enable {
    mynix.services.localHttpsProxy = {
      enable = true;
      virtualHosts."mo.lvh.me".upstream = "127.0.0.1:6275";
    };
  };
}
