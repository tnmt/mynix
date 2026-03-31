{
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
  ];

  # Display manager
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
      user = "greeter";
    };
  };

  # Networking
  networking.wireless.iwd.enable = true;
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  services.resolved.enable = true;

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
