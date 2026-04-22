# Shared content builder for ~/.ssh/conf.d/private.config.
# Consumed by profiles/{darwin,nixos}/ssh-private.nix. The LAN prefix
# (first three octets of the private subnet) and the vps01 FQDN are
# substituted from sops secrets at activation time via
# config.sops.placeholder.<name>, so only non-identifying tokens
# (host-suffix octets, local aliases, ports) live in plaintext Nix.
# Tailscale -ts aliases resolve via MagicDNS and can be toggled per host.
{
  lanPrefix,
  vps01Host,
  includeTailscale,
}:
let
  base = ''
    # github.com (personal)
    Host github.com
        HostName github.com
        User git
        ControlMaster no
        ControlPath none

    # VPS (always on)
    Host vps01
        HostName ${vps01Host}

    # RDP port-forward entrypoint
    Host rdp-sunflower
        HostName ${vps01Host}
        LocalForward 13389 sunflower:3389

    # === sunflower (Windows SSH, port 22) ===
    Host sunflower
        HostName ${lanPrefix}.10
        Port 22
        ControlMaster no
        ProxyCommand sh -c 'timeout 2 nc -z sunflower %p 2>/dev/null && exec nc sunflower %p || exec ssh -W sunflower:%p vps01'

    # === sunflower-wsl (WSL2 SSH, port 2222) ===
    Host sunflower-wsl
        HostName ${lanPrefix}.10
        Port 2222
        ControlMaster no
        ProxyCommand sh -c 'timeout 2 nc -z sunflower %p 2>/dev/null && exec nc sunflower %p || exec ssh -W sunflower:%p vps01'

    # === dahlia ===
    Host dahlia
        HostName ${lanPrefix}.15
        ControlMaster no
        ProxyCommand sh -c 'timeout 2 nc -z dahlia %p 2>/dev/null && exec nc dahlia %p || exec ssh -W dahlia:%p vps01'

    # === obsync (via sunflower-wsl) ===
    Host obsync
        HostName ${lanPrefix}.40
        ControlMaster no
        ProxyCommand sh -c 'timeout 2 nc -z obsync %p 2>/dev/null && exec nc obsync %p || exec ssh -W %h:%p sunflower-wsl'

    # === silvea (via sunflower-wsl) ===
    Host silvea
        HostName ${lanPrefix}.41
        ControlMaster no
        ProxyCommand sh -c 'timeout 2 nc -z %h %p 2>/dev/null && exec nc %h %p || exec ssh -W %h:%p sunflower-wsl'
  '';

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
