# Shared content builder for ~/.ssh/conf.d/private.config.
# Consumed by home-manager/base/programs/ssh-private.nix and
# profiles/nixos/wsl.nix. The LAN prefix (first three octets of the
# private subnet) and the vps01 FQDN are substituted from sops secrets
# at activation time via config.sops.placeholder.<name>, so only
# non-identifying tokens (host-suffix octets, local aliases, ports)
# live in plaintext Nix. Tailscale -ts aliases resolve via MagicDNS.
#
# tier = "laptop":      public path only — github, vps01, sunflower,
#                       rdp-sunflower. Tailscale aliases limited to
#                       sunflower variants.
# tier = "workstation": adds the LAN hub view — dahlia + obsync + silvea.
#                       Tailscale aliases also include dahlia/obsync.
#                       Sunflower itself is the workstation, so on
#                       sunflower-wsl (wslLocal = true) self-reference
#                       blocks are dropped and LAN hosts are reached
#                       directly instead of via ProxyJump sunflower-wsl.
{
  lanPrefix,
  vps01Host,
  tier,
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

  sunflowerPart = if wslLocal then "" else sunflowerBlocks;

  lanPart =
    if tier == "workstation" then
      dahliaBlock + (if wslLocal then lanHostsDirect else lanHostsViaJump)
    else
      "";

  tailscalePart =
    if includeTailscale then
      tailscaleSunflower + (if tier == "workstation" then tailscaleLan else "")
    else
      "";
in
header + sunflowerPart + lanPart + tailscalePart
