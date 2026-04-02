{ lib, ... }:
{
  programs.ssh.startAgent = true;

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
    };
  };
}
