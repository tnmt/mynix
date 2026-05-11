# Baseline host firewall.
#
# NixOS enables the firewall by default, but keeping the declaration
# explicit here makes the boundary legible in this repo instead of
# relying on implicit nixpkgs defaults. Per-host ports should be
# opened in the host's nixos.nix (allowedTCPPorts / allowedUDPPorts)
# — services that know their port (e.g. services.openssh) already
# poke the firewall themselves via openFirewall defaults.
{ config, lib, ... }:
let
  netbirdInterfaces = lib.mapAttrsToList (_: c: c.interface) config.services.netbird.clients;
in
{
  networking.firewall = {
    enable = lib.mkDefault true;

    # Trust mesh-VPN interfaces (Tailscale, NetBird) so peers can reach
    # any service this host exposes without per-port rules. Peer-to-peer
    # access control is enforced by each control plane (Tailscale ACLs /
    # NetBird Dashboard policies), not the host firewall.
    trustedInterfaces = lib.optional config.services.tailscale.enable "tailscale0" ++ netbirdInterfaces;
  };

  # Disable reverse-path filtering on NetBird tunnel interfaces. With the
  # systemd loose default (rp_filter=2), inbound payload packets arriving
  # via the NetBird WG tunnel are silently dropped on a multi-homed host
  # — WG handshakes still succeed but ping/SSH never reach userspace.
  # systemd-sysctl re-applies these values when the interface appears,
  # so per-interface keys in boot.kernel.sysctl work even though the
  # interface doesn't exist at boot.
  boot.kernel.sysctl = lib.listToAttrs (
    map (c: lib.nameValuePair "net.ipv4.conf.${c.interface}.rp_filter" 0) (
      lib.attrValues config.services.netbird.clients
    )
  );
}
