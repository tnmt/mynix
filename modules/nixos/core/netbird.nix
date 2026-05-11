# Cross-cutting fixes for NetBird clients.
#
# Without an explicit `dns-resolver.address`, NetBird's embedded DNS
# resolver tries to bind on the client's dynamic NetBird IP at :53.
# Two failure modes follow under `hardened = true`:
#
# 1. nixpkgs only grants CAP_NET_BIND_SERVICE when `dns-resolver.address`
#    is set with `port < 1024`, so the default binding fails with
#    "bind: permission denied" and *.netbird.selfhosted stops resolving.
# 2. Even with the capability granted, queries from the host itself go
#    src=dst=<own NetBird IP> (loopback to its own WG address), which
#    NetBird's resolver answers selectively or not at all — peer-to-peer
#    queries work, but the host's own resolver requests time out.
#
# Pin the resolver to 127.0.0.1:53 by default for every client. The
# loopback address is stable, satisfies nixpkgs' capability condition
# (so CAP_NET_BIND_SERVICE is granted automatically), and host-local
# DNS queries return correctly because src/dst differ.
{ lib, ... }:
{
  options.services.netbird.clients = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        config.dns-resolver.address = lib.mkDefault "127.0.0.1";
      }
    );
  };
}
