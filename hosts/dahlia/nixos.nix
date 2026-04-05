{
  config,
  inputs,
  lib,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./hardware.nix
    ../../modules/core
    ../../modules/programs/shell.nix
    ../../modules/programs/openssh.nix
    ../../modules/programs/virtualisation.nix
    ../../profiles/laptop.nix
    ../../profiles/hyprland-desktop.nix
    ../../profiles/japanese-keyboard.nix
  ];

  # Networking (dahlia-specific: static IP on homelab WiFi)
  networking.networkmanager = {
    enable = true;
    ensureProfiles.environmentFiles = [
      config.sops.templates."wifi-env".path
    ];
    ensureProfiles.profiles = {
      homelab = {
        connection = {
          id = "homelab";
          type = "wifi";
          autoconnect = true;
          autoconnect-priority = 100;
        };
        wifi = {
          ssid = "$WIFI_HOMELAB_SSID";
          mode = "infrastructure";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$WIFI_HOMELAB_PSK";
        };
        ipv4 = {
          method = "manual";
          address1 = "$DAHLIA_IP_WITH_PREFIX,$DAHLIA_GATEWAY";
          dns = "$DAHLIA_DNS;";
        };
      };
    };
  };
  services.resolved.enable = true;

  # Tailscale VPN
  services.tailscale.enable = true;

  # Firewall
  networking.firewall.enable = true;

  # Secrets (dahlia-specific)
  sops = {
    defaultSopsFile = ../../secrets/dahlia.yaml;
    age.keyFile = "${config.users.users.${username}.home}/.config/sops/age/keys.txt";
    secrets.wifi_homelab_ssid = { };
    secrets.wifi_homelab_psk = { };
    secrets.dahlia_ip_with_prefix = { };
    secrets.dahlia_gateway = { };
    secrets.dahlia_dns = { };
    templates."wifi-env" = {
      content = ''
        WIFI_HOMELAB_SSID=${config.sops.placeholder.wifi_homelab_ssid}
        WIFI_HOMELAB_PSK=${config.sops.placeholder.wifi_homelab_psk}
        DAHLIA_IP_WITH_PREFIX=${config.sops.placeholder.dahlia_ip_with_prefix}
        DAHLIA_GATEWAY=${config.sops.placeholder.dahlia_gateway}
        DAHLIA_DNS=${config.sops.placeholder.dahlia_dns}
      '';
    };
  };

  users.users."${username}".extraGroups = [
    "wheel"
    "networkmanager"
    "docker"
  ];

  home-manager.users."${username}" = import ./home-manager.nix;
}
