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

    inputs.home-manager.nixosModules.home-manager
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
          addresses = "REDACTED/24";
          gateway = "REDACTED";
          dns = "REDACTED";
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
    templates."wifi-env" = {
      content = ''
        WIFI_HOMELAB_SSID=${config.sops.placeholder.wifi_homelab_ssid}
        WIFI_HOMELAB_PSK=${config.sops.placeholder.wifi_homelab_psk}
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

  # home-manager as NixOS module
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs username;
      theme = (import ../../themes) "tokyonight-storm";
      pkgs-stable = pkgs;
    };
    users."${username}" = import ./home-manager.nix;
  };
}
