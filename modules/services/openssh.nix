{ lib, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = lib.mkDefault false;
      KbdInteractiveAuthentication = lib.mkDefault false;
      PermitRootLogin = lib.mkDefault "no";
      X11Forwarding = lib.mkDefault false;
      MaxAuthTries = lib.mkDefault 3;
      ClientAliveInterval = lib.mkDefault 300;
      ClientAliveCountMax = lib.mkDefault 2;

      # Defense-in-depth: pin the auth method explicitly even though
      # PasswordAuthentication / KbdInteractiveAuthentication are off.
      AuthenticationMethods = lib.mkDefault "publickey";

      # Tighten the brute-force window (default 120s).
      LoginGraceTime = lib.mkDefault 30;

      # Log the public key fingerprint used for each auth attempt so
      # fail2ban / forensics can correlate by key, not just IP.
      LogLevel = lib.mkDefault "VERBOSE";
    };
  };
}
