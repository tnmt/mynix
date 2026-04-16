# Hyprland desktop system profile
# - Greetd display manager with tuigreet
# - Hyprland compositor
# - Desktop environment (fonts, sound, fcitx5, security)
# - Bluetooth
# - VM variant for testing
{
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/desktop/hyprland-system.nix
    ../../modules/hardware/bluetooth.nix
    ../../modules/desktop
  ];

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd 'uwsm start -D Hyprland hyprland.desktop'";
      user = "greeter";
    };
  };

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores = 4;
      graphics = true;
    };
  };
}
