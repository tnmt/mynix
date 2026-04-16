{
  config,
  username,
  ...
}:
let
  services = import ../../modules/services;
in
{
  imports = [
    ./hardware.nix
    ../../modules/core
    services.openssh
    ../../modules/programs/virtualisation.nix
    ../../modules/hardware/power-management.nix
    ../../profiles/nixos/desktop-hyprland.nix
    ../../profiles/nixos/homelab-wifi-static.nix
    ../../modules/hardware/kanata.nix
  ];

  # Tailscale VPN
  services.tailscale.enable = true;

  # Firewall
  networking.firewall.enable = true;

  # Secrets (dahlia-specific)
  sops = {
    defaultSopsFile = ../../secrets/dahlia.yaml;
    age.keyFile = "${config.users.users.${username}.home}/.config/sops/age/keys.txt";
  };

  security.sudo.wheelNeedsPassword = false;

  users.users."${username}" = {
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    linger = true;
  };

  home-manager.users."${username}" = import ./home-manager.nix;
}
