# dahlia-specific homelab profile (wired + Wi-Fi), backed by sops secrets.
# Wired LAN is the primary path (lower metric, higher autoconnect-priority);
# Wi-Fi is a fallback on a distinct host octet so both NICs can co-exist on
# the same subnet without ARP-flux. Homelab-wide values (subnet prefix,
# Wi-Fi creds) live in secrets/roles/personal.yaml so they can be shared
# with future homelab nodes; host-scoped values (NIC MAC) live in
# secrets/hosts/dahlia.yaml via the host's defaultSopsFile.
{
  config,
  ...
}:
let
  # Non-identifying host/subnet layout; LAN prefix is substituted from sops.
  wiredHostOctet = "15";
  wifiHostOctet = "16";
  gatewayOctet = "1";
  prefixLength = "24";
  lanPrefix = config.sops.placeholder.lan_prefix;
in
{
  networking.networkmanager = {
    enable = true;
    ensureProfiles.environmentFiles = [
      config.sops.templates."homelab-env".path
    ];
    ensureProfiles.profiles = {
      homelab-wired = {
        connection = {
          id = "homelab-wired";
          type = "ethernet";
          autoconnect = true;
          autoconnect-priority = 200;
        };
        # MAC でNICを固定。USBアダプタは挿し位置でinterface名が変わるため、
        # interface-nameではなくMACで束ねる。
        ethernet = {
          mac-address = "$WIRED_MAC";
        };
        ipv4 = {
          method = "manual";
          address1 = "$WIRED_IP_WITH_PREFIX,$GATEWAY";
          dns = "$DNS;";
          route-metric = "50";
        };
        ipv6.method = "ignore";
      };
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
          address1 = "$WIFI_IP_WITH_PREFIX,$GATEWAY";
          dns = "$DNS;";
          route-metric = "600";
        };
      };
    };
  };

  # ARP-flux抑制: 同一サブネットに 2 NIC が居る前提。各 NIC は自分に付いた
  # IP の ARP だけ応答し、送信時は出力 NIC の IP で広告する。これでスイッチ
  # の MAC テーブルが安定し、.15 は有線・.16 は Wi-Fi 経由で確定到達。
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.arp_ignore" = 1;
    "net.ipv4.conf.all.arp_announce" = 2;
  };

  services.resolved.enable = true;

  sops = {
    secrets = {
      # Host-scoped (NIC MAC) — from defaultSopsFile (secrets/hosts/dahlia.yaml).
      wired_mac = { };
      # Homelab-wide (subnet prefix, Wi-Fi creds) — shared across nodes.
      lan_prefix = {
        sopsFile = ../../secrets/roles/personal.yaml;
      };
      wifi_homelab_ssid = {
        sopsFile = ../../secrets/roles/personal.yaml;
      };
      wifi_homelab_psk = {
        sopsFile = ../../secrets/roles/personal.yaml;
      };
    };
    templates."homelab-env" = {
      content = ''
        WIFI_HOMELAB_SSID=${config.sops.placeholder.wifi_homelab_ssid}
        WIFI_HOMELAB_PSK=${config.sops.placeholder.wifi_homelab_psk}
        WIRED_MAC=${config.sops.placeholder.wired_mac}
        WIRED_IP_WITH_PREFIX=${lanPrefix}.${wiredHostOctet}/${prefixLength}
        WIFI_IP_WITH_PREFIX=${lanPrefix}.${wifiHostOctet}/${prefixLength}
        GATEWAY=${lanPrefix}.${gatewayOctet}
        DNS=${lanPrefix}.${gatewayOctet}
      '';
    };
  };
}
