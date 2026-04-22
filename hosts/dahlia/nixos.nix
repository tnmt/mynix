{
  username,
  ...
}:
let
  services = import ../../modules/services;
  pubkeys = import ../../modules/common/ssh-pubkeys.nix;
in
{
  imports = [
    ./hardware.nix

    # Shared system roles.
    ../../modules/nixos/core
    services."openssh"
    ../../modules/programs/virtualisation.nix
    ../../modules/hardware/power-management.nix
    ../../profiles/nixos/desktop-hyprland.nix
    ../../profiles/nixos/homelab-wifi-static.nix
    ../../modules/hardware/kanata.nix
  ];

  # Host-local networking and access.
  services.tailscale.enable = true;

  # SSH Term on zfold7 lacks ETM MAC support; allow non-ETM SHA-2 on
  # this host only. ETM variants remain preferred; sha1/md5 stay out.
  services.openssh.settings.Macs = [
    "hmac-sha2-512-etm@openssh.com"
    "hmac-sha2-256-etm@openssh.com"
    "umac-128-etm@openssh.com"
    "hmac-sha2-512"
    "hmac-sha2-256"
  ];

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
      hosts.zfold7
    ];
  };

  # Host-specific Home Manager entrypoint.
  home-manager.users."${username}" = import ./home-manager.nix;
}
