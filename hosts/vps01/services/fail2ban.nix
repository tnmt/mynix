{ config, pkgs, ... }:
{
  sops.templates."fail2ban-ignoreip" = {
    content = "${config.sops.placeholder.trusted_ip_home} ${config.sops.placeholder.trusted_ip_homelab} ${config.sops.placeholder.trusted_ip_office} 100.64.0.0/10";
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "10m";
    jails = {
      sshd = {
        settings = {
          enabled = true;
          journalmatch = "_SYSTEMD_UNIT=sshd.service";
          ignorecommand = "${pkgs.bash}/bin/bash -c '${pkgs.gnugrep}/bin/grep -qw <ip> ${config.sops.templates."fail2ban-ignoreip".path}'";
        };
      };
    };
  };
}
