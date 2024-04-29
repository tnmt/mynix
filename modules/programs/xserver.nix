{
  services.xserver = {
    enable = true;
    autoRepeatDelay = 300;
    autoRepeatInterval = 30;
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };
    displayManager = {
      gdm.enable = true;
    };
    xkb = {
      layout = "us";
      variant = "";
      options = "ctrl:nocaps, ";
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
