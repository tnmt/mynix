# Shared content builder for ~/.ssh/conf.d/private.config.
# Consumed by profiles/{darwin,nixos}/ssh-private.nix. The LAN prefix
# (first three octets of the private subnet) and the vps01 FQDN are
# substituted from sops secrets at activation time via
# config.sops.placeholder.<name>, so only non-identifying tokens
# (host-suffix octets, local aliases, ports) live in plaintext Nix.
# Tailscale -ts aliases resolve via MagicDNS and can be toggled per host.
#
# wslLocal = true when the config is rendered on sunflower-wsl itself.
# In that mode the sunflower/sunflower-wsl/rdp-sunflower entries are
# dropped (self-reference) and obsync/silvea reach the LAN directly
# instead of jumping through sunflower-wsl.
{
  lanPrefix,
  vps01Host,
  includeTailscale,
  wslLocal ? false,
}:
let
  header = ''
    # github.com (personal)
    Host github.com
        HostName github.com
        User git
        ControlMaster no
        ControlPath none

    # VPS (always on)
    Host vps01
        HostName ${vps01Host}
  '';

  sunflowerBlocks = ''

    # RDP port-forward entrypoint
    Host rdp-sunflower
        HostName ${vps01Host}
        LocalForward 13389 sunflower:3389

    # === sunflower (Windows SSH, port 22) ===
    # Probe via Tailscale MagicDNS (direct peer). Fall back to vps01
    # jump when the peer is unreachable (e.g. Tailscale down).
    Match host sunflower !exec "nc -z -w2 sunflower 22 2>/dev/null"
        ProxyJump vps01
    Host sunflower
        HostName sunflower
        Port 22
        ControlMaster no

    # === sunflower-wsl (WSL2 SSH, port 2222) ===
    Match host sunflower-wsl !exec "nc -z -w2 sunflower 2222 2>/dev/null"
        ProxyJump vps01
    Host sunflower-wsl
        HostName sunflower
        Port 2222
        ControlMaster no
  '';

  dahliaBlock = ''

    # === dahlia ===
    Match host dahlia !exec "nc -z -w2 dahlia 22 2>/dev/null"
        ProxyJump vps01
    Host dahlia
        HostName dahlia
        ControlMaster no
  '';

  lanHostsViaJump = ''

    # === obsync (via sunflower-wsl) ===
    Host obsync
        HostName ${lanPrefix}.40
        ControlMaster no
        ProxyJump sunflower-wsl

    # === silvea (via sunflower-wsl) ===
    Host silvea
        HostName ${lanPrefix}.41
        ControlMaster no
        ProxyJump sunflower-wsl
  '';

  lanHostsDirect = ''

    # === obsync (LAN direct) ===
    Host obsync
        HostName ${lanPrefix}.40
        ControlMaster no

    # === silvea (LAN direct) ===
    Host silvea
        HostName ${lanPrefix}.41
        ControlMaster no
  '';

  base =
    header
    + (if wslLocal then "" else sunflowerBlocks)
    + dahliaBlock
    + (if wslLocal then lanHostsDirect else lanHostsViaJump);

  tailscale = ''

    # === Tailscale (MagicDNS) ===
    Host sunflower-ts
        HostName sunflower
        Port 22

    Host sunflower-wsl-ts
        HostName sunflower
        Port 2222

    Host dahlia-ts
        HostName dahlia

    Host obsync-ts
        HostName obsync
  '';
in
base + (if includeTailscale then tailscale else "")
