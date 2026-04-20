{
  username,
  ...
}:
let
  services = import ../../modules/services;
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
  };

  # Host-specific Home Manager entrypoint.
  home-manager.users."${username}" = import ./home-manager.nix;
}
