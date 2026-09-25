# Hyprland desktop system profile
# - Greetd display manager with tuigreet
# - Hyprland compositor
# - Desktop environment (fonts, sound, fcitx5, security)
# - Bluetooth
# - Noctalia desktop shell (bar/launcher/lock screen/OSD/wallpaper) service prerequisites
# - VM variant for testing
{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/programs/hyprland.nix
    ../../modules/programs/gpu-screen-recorder.nix
    ../../modules/hardware/bluetooth.nix
    ../../modules/desktop
    inputs.noctalia.nixosModules.default
  ];

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd 'uwsm start -D Hyprland hyprland.desktop'";
      user = "greeter";
    };
  };

  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores = 4;
      graphics = true;
    };
  };
}
