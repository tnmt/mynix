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
  networking.firewall.enable = true;

  security.sudo.wheelNeedsPassword = false;

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
      legacy.workmac_rsa
      legacy.unknown_ed25519
    ];
  };

  # Host-specific Home Manager entrypoint.
  home-manager.users."${username}" = import ./home-manager.nix;
}
