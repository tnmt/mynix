{ ... }:
{
  services.postfix = {
    enable = true;
    settings = {
      main = {
        myhostname = "vps01.tnmt.info";
        myorigin = "tnmt.info";
        mydestination = [
          "vps01.tnmt.info"
          "localhost.tnmt.info"
          "localhost"
        ];
        mynetworks = [
          "127.0.0.0/8"
          "[::ffff:127.0.0.0]/104"
          "[::1]/128"
        ];
        smtp_tls_security_level = "may";
        smtpd_tls_security_level = "may";
        smtpd_relay_restrictions = "permit_mynetworks permit_sasl_authenticated defer_unauth_destination";
        mailbox_size_limit = "0";
        recipient_delimiter = "+";
        inet_interfaces = "all";
        inet_protocols = "all";
        default_transport = "smtp";
        relay_transport = "smtp";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 25 ];
}
