# Shared content builder for ~/.ssh/conf.d/private.config.
# Consumed by home-manager/base/programs/ssh-private.nix and
# profiles/nixos/wsl.nix. The LAN prefix (first three octets of the
# private subnet) and the vps01 FQDN are substituted from sops secrets
# at activation time via config.sops.placeholder.<name>, so only
# non-identifying tokens (host-suffix octets, local aliases, ports)
# live in plaintext Nix. Tailscale -ts aliases resolve via MagicDNS.
#
# tier = "laptop":      public path only — github, vps01, and the
#                       sunflower entrypoint blocks (jump via vps01 on
#                       Tailscale miss). Tailscale aliases limited to
#                       sunflower variants.
# tier = "workstation": the LAN hub itself. Self-reference sunflower
#                       blocks are dropped (useless on the hub), and
#                       LAN peers (dahlia, obsync, silvea) are reached
#                       directly instead of via ProxyJump. Tailscale
#                       aliases also include the LAN peers.
#
# The hub-is-workstation coupling is intentional: there is no current
# use case for a non-hub workstation. If one appears, re-introduce a
# `selfIsHub` flag rather than guessing from tier.
{
  lanPrefix,
  vps01Host,
  tier,
  includeTailscale,
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

  lanHosts = ''

    # === dahlia ===
    Match host dahlia !exec "nc -z -w2 dahlia 22 2>/dev/null"
        ProxyJump vps01
    Host dahlia
        HostName dahlia
        ControlMaster no

    # === obsync (LAN direct) ===
    Host obsync
        HostName ${lanPrefix}.40
        ControlMaster no

    # === silvea (LAN direct) ===
    Host silvea
        HostName ${lanPrefix}.41
        ControlMaster no
  '';

  tailscaleSunflower = ''

    # === Tailscale (MagicDNS) ===
    Host sunflower-ts
        HostName sunflower
        Port 22

    Host sunflower-wsl-ts
        HostName sunflower
        Port 2222
  '';

  tailscaleLan = ''

    Host dahlia-ts
        HostName dahlia

    Host obsync-ts
        HostName obsync
  '';

  laptopPart = sunflowerBlocks;
  workstationPart = lanHosts;

  tierPart = if tier == "workstation" then workstationPart else laptopPart;

  tailscalePart =
    if includeTailscale then
      tailscaleSunflower + (if tier == "workstation" then tailscaleLan else "")
    else
      "";
in
header + tierPart + tailscalePart
