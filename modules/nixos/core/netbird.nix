# Cross-cutting fixes for NetBird clients.
#
# nixpkgs' netbird module only adds CAP_NET_BIND_SERVICE when
# `dns-resolver.address` is explicitly set with `port < 1024`. With the
# default (`address = null`), NetBird still tries to bind its embedded
# DNS resolver on the client's dynamic NetBird IP at :53, which fails
# with "bind: permission denied" under `hardened = true`. The host's
# resolved registers that address as the DNS server for the tunnel
# interface, so the failed bind manifests as *.netbird.selfhosted not
# resolving on the host.
#
# Grant CAP_NET_BIND_SERVICE unconditionally to every hardened NetBird
# client so the embedded DNS resolver can bind on its dynamic address.
{ config, lib, ... }:
{
  systemd.services = lib.mapAttrs' (
    name: client:
    lib.nameValuePair "netbird-${name}" (
      lib.mkIf client.hardened {
        serviceConfig.AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
      }
    )
  ) config.services.netbird.clients;
}
