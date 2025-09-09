{
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../../modules/core
    ../../modules/desktop
    ../../modules/programs/shell.nix
    ../../modules/programs/hyprland.nix
  ];

  boot.loader.grub.enable = false;

  fileSystems."/" = {
    device = "/dev/sda";
    fsType = "ext4";
  };

  users.users."${username}" = {
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.zsh;
    group = "users";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Make sure legacy X11/GDM does not start; use Wayland Hyprland via greetd
  services.xserver.enable = false;
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = false;

  # Enable Hyprland compositor on this host
  programs.hyprland.enable = true;

  # Prefer Hyprland's XDG portal system-wide on this host
  xdg.portal = {
    enable = true;
    # Let Hyprland's module provide the hyprland portal to avoid duplicates
    config.common.default = pkgs.lib.mkForce "hyprland";
  };

  # Auto-start Hyprland at boot using greetd
  services.greetd = {
    enable = true;
    settings = {
      # Auto login directly into Hyprland for this user
      initial_session = {
        command = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.hyprland}/bin/Hyprland";
        user = username;
      };

      # Fallback TUI greeter if user logs out to greeter
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${pkgs.hyprland}/bin/Hyprland";
        user = "greeter";
      };
    };
  };
}
