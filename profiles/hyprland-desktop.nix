# Hyprland desktop workstation profile
# - Greetd display manager with tuigreet
# - Hyprland compositor
# - Desktop environment (fonts, sound, fcitx5, security)
# - Bluetooth
# - GNOME Keyring handles ssh-agent (disable openssh's)
# - VM variant for testing
{
  inputs,
  lib,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../modules/programs/hyprland.nix
    ../modules/programs/bluetooth.nix
    ../modules/desktop
  ];

  # Display manager
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
      user = "greeter";
    };
  };

  # Disable ssh-agent from openssh (GNOME Keyring handles it on desktop)
  programs.ssh.startAgent = lib.mkForce false;

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
}
