{ lib, pkgs, ... }:
{
  imports = [
    ./gh-triage
  ];

  # Work machines don't run Tailscale, so skip the -ts MagicDNS aliases in
  # ~/.ssh/conf.d/private.config. The LAN/ProxyJump entries still apply.
  profiles.sshPrivate.includeTailscale = false;

  home.packages =
    with pkgs;
    [
      consul-template
      kagiana
      openstackclient
      vault
    ]
    ++ lib.optionals stdenv.isLinux [
      _1password-cli
    ];
}
