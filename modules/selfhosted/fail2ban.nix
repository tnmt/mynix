{ ... }:
{
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "10m";
    jails = {
      sshd = {
        settings = {
          enabled = true;
        };
      };
    };
  };
}
