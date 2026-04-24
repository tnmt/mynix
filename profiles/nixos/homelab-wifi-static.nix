# Static Wi-Fi profile for the homelab network, backed by sops secrets.
# The LAN prefix (first three octets of the private subnet) is rendered
# from secrets/roles/personal.yaml via sops.placeholder at activation
# time, so the dahlia host octet and prefix length can live in plaintext
# Nix while subnet layout stays out of the public repo. Mirrors the SSH
# private.config pattern in home-manager/base/programs/ssh-private.nix.
{
  config,
  ...
}:
let
  # Non-identifying host/subnet layout; LAN prefix is substituted from sops.
  hostOctet = "15";
  gatewayOctet = "1";
  prefixLength = "24";
  lanPrefix = config.sops.placeholder.lan_prefix;
in
{
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

  sops = {
    secrets = {
      wifi_homelab_ssid = { };
      wifi_homelab_psk = { };
      lan_prefix = {
        sopsFile = ../../secrets/roles/personal.yaml;
      };
    };
    templates."wifi-env" = {
      content = ''
        WIFI_HOMELAB_SSID=${config.sops.placeholder.wifi_homelab_ssid}
        WIFI_HOMELAB_PSK=${config.sops.placeholder.wifi_homelab_psk}
        DAHLIA_IP_WITH_PREFIX=${lanPrefix}.${hostOctet}/${prefixLength}
        DAHLIA_GATEWAY=${lanPrefix}.${gatewayOctet}
        DAHLIA_DNS=${lanPrefix}.${gatewayOctet}
      '';
    };
  };
}
