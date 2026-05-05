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

    # Trust mesh-VPN interfaces (Tailscale, NetBird) so peers can reach
    # any service this host exposes without per-port rules. Peer-to-peer
    # access control is enforced by each control plane (Tailscale ACLs /
    # NetBird Dashboard policies), not the host firewall.
    trustedInterfaces =
      lib.optional config.services.tailscale.enable "tailscale0"
      ++ lib.mapAttrsToList (_: c: c.interface) config.services.netbird.clients;
  };
}
