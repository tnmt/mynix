{ lib, ... }:
{
  programs.ssh.startAgent = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = lib.mkDefault true;
    };
  };
}
