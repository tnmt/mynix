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
    ../../modules/programs/bluetooth.nix
    ../../modules/programs/hyprland.nix
    ../../modules/programs/virtualisation.nix
    ../../modules/desktop

    inputs.sops-nix.nixosModules.sops
  ];

  # Display manager
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
      user = "greeter";
    };
  };

  # Networking
  networking.wireless.iwd.enable = true;
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    ensureProfiles.environmentFiles = [
      config.sops.templates."wifi-env".path
    ];
    ensureProfiles.profiles = {
      homelab = {
        connection = {
          id = "homelab";
          type = "wifi";
          interface-name = "wlan0";
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
          addresses = "$DAHLIA_IP";
          gateway = "$DAHLIA_GATEWAY";
          dns = "$DAHLIA_DNS";
        };
      };
    };
  };
  services.resolved.enable = true;

  # Secrets
  sops = {
    defaultSopsFile = ../../secrets/dahlia.yaml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    secrets.wifi_homelab_ssid = { };
    secrets.wifi_homelab_psk = { };
    secrets.dahlia_ip = { };
    secrets.dahlia_gateway = { };
    secrets.dahlia_dns = { };
    templates."wifi-env" = {
      content = ''
        WIFI_HOMELAB_SSID=${config.sops.placeholder.wifi_homelab_ssid}
        WIFI_HOMELAB_PSK=${config.sops.placeholder.wifi_homelab_psk}
        DAHLIA_IP=${config.sops.placeholder.dahlia_ip}
        DAHLIA_GATEWAY=${config.sops.placeholder.dahlia_gateway}
        DAHLIA_DNS=${config.sops.placeholder.dahlia_dns}
      '';
    };
  };

  # Tailscale VPN
  services.tailscale.enable = true;

  # Firewall
  networking.firewall.enable = true;

  # Key remapping (keyd)
  services.keyd = {
    enable = true;
    keyboards.default.settings = {
      main = {
        capslock = "leftcontrol";
        yen = "backslash";
        ro = "grave";
        leftalt = "overload(alt, muhenkan)";
        rightalt = "overload(alt, henkan)";
      };
    };
  };

  # Disable ssh-agent from openssh (GNOME Keyring handles it on desktop)
  programs.ssh.startAgent = lib.mkForce false;

  # Power management
  services.power-profiles-daemon.enable = true;

  # User
  users.users."${username}" = {
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.zsh;
    group = "users";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
  };

  # VM testing (ignored on real hardware)
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores = 4;
      graphics = true;
    };
  };

  # Auto-login for VM convenience
  services.getty.autologinUser = username;

  home-manager.users."${username}" = import ./home-manager.nix;
}
