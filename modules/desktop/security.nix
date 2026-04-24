{
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  security = {
    polkit.enable = true;
    pam.services = {
      login.enableGnomeKeyring = true;
      greetd.enableGnomeKeyring = true;

      # wayland display lockers (e.g. swaylock) needs this
      swaylock.text = "auth include login";
    };
  };
}
