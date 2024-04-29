{inputs, ...}: {
  imports = [inputs.hyprland.nixosModules.default];
  programs.hyprland.enable = true;

  security.pam.services.swaylock.text = "auth include login";
}
