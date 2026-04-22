# Kernel attack-surface reduction.
#
# Blacklist legacy/rare network protocol modules that this fleet
# never uses. Auto-loading of these has historically been an entry
# point for kernel CVEs (e.g. DCCP use-after-free CVE-2017-6074,
# TIPC heap overflow CVE-2022-0435). Zero runtime cost — we simply
# refuse to load something we don't deploy.
#
# Scope is deliberately narrow. Broader sysctl / AppArmor / audit
# hardening was considered against this fleet's threat model
# (single-admin home lab, publickey-only SSH behind NAT or
# Tailscale) and declined as not worth the additional surface in
# the repo. See memory/project_hardening_roadmap.md for that
# analysis.
{
  boot.blacklistedKernelModules = [
    "sctp"
    "dccp"
    "rds"
    "tipc"
  ];
}
