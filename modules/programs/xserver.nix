{
  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
    };
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  #services.xserver.desktopManager.gnome.enable = true;

  # Enable automatic login for the user.
  #services.displayManager.autoLogin.enable = true;
  #services.displayManager.autoLogin.user = "tnmt";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  #systemd.services."getty@tty1".enable = false;
  #systemd.services."autovt@tty1".enable = false;
}
