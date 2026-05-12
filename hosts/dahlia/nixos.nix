{
  username,
  ...
}:
let
  services = import ../../modules/nixos/services;
  pubkeys = import ../../modules/common/ssh-pubkeys.nix;
in
{
  imports = [
    ./hardware.nix
    ./disko.nix
    ./network.nix

    # Shared system roles.
    ../../modules/nixos/core
    services."openssh"
    services."ccpocket-bridge"
    ../../modules/programs/virtualisation.nix
    ../../modules/hardware/power-management.nix
    ../../profiles/nixos/desktop-hyprland.nix
    ../../profiles/nixos/givy.nix
    ../../profiles/nixos/netbird.nix
    ../../modules/hardware/kanata.nix
  ];

  # Host-local networking and access.
  services.tailscale = {
    enable = true;
    # Hand DNS control back to systemd-resolved so the NetBird-managed
    # search domain and resolver (127.0.0.1) own the host's resolution
    # path. Tailscale's MagicDNS short names go away — peers are now
    # addressed as `<peer>.netbird.selfhosted` (or just `<peer>` via
    # the NetBird search domain added by modules/nixos/core/netbird.nix).
    extraSetFlags = [ "--accept-dns=false" ];
  };
  mynix.profiles.netbird.enable = true;

  mynix.profiles.givy = {
    enable = true;
    instances.github = {
      root = "/home/${username}/ghq/github.com";
      port = 6271;
    };
    trustedRootCAFile = ./caddy-local-ca.crt;
  };

  # Dropbox LANSync: TCP=peer転送, UDP=ブロードキャスト発見
  networking.firewall = {
    allowedTCPPorts = [ 17500 ];
    allowedUDPPorts = [ 17500 ];
  };

  profiles.userTemplates = {
    enable = true;
    voiceInput = true;
    sshPrivate = {
      role = "client";
      tier = "laptop";
    };
  };

  users.users."${username}" = {
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    linger = true;
    # Declarative authorized_keys. Lives at /etc/ssh/authorized_keys.d/<user>;
    # the manual ~/.ssh/authorized_keys is still read by sshd until removed,
    # so it is safe to roll this out before cleaning up the manual file.
    openssh.authorizedKeys.keys = with pubkeys; [
      hosts.work_mac
      hosts.sunflower
      hosts.hydrangea
      mobile.zfold7SshTerm
      mobile.iphone13miniSshTerm
    ];
  };

  # Host-specific Home Manager entrypoint.
  home-manager.users."${username}" = import ./home-manager.nix;
}
