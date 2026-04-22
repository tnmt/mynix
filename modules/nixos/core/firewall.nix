# Baseline host firewall.
#
# NixOS enables the firewall by default, but keeping the declaration
# explicit here makes the boundary legible in this repo instead of
# relying on implicit nixpkgs defaults. Per-host ports should be
# opened in the host's nixos.nix (allowedTCPPorts / allowedUDPPorts)
# — services that know their port (e.g. services.openssh) already
# poke the firewall themselves via openFirewall defaults.
{ config, lib, ... }:
{
  networking.firewall = {
    enable = lib.mkDefault true;

    # Trust the tailnet interface when Tailscale is running so peers
    # can reach any service this host exposes on tailscale0 without
    # per-port rules. Mirrors Tailscale's recommended setup.
    trustedInterfaces = lib.mkIf config.services.tailscale.enable [ "tailscale0" ];
  };
}
