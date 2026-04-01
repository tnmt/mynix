{ ... }:
{
  services.adguardhome = {
    enable = true;
    port = 8000;
    settings = {
      dns = {
        bind_hosts = [ "0.0.0.0" ];
        port = 53;
        ratelimit = 20;
        refuse_any = true;
        upstream_dns = [
          "https://1.1.1.1/dns-query"
          "https://1.0.0.1/dns-query"
        ];
        bootstrap_dns = [
          "1.1.1.1"
          "1.0.0.1"
          "2620:fe::10"
          "2620:fe::fe:10"
        ];
        upstream_mode = "load_balance";
        cache_enabled = true;
        cache_size = 4194304;
      };
    };
  };

  # Disable systemd-resolved to free port 53
  services.resolved.enable = false;
  networking.nameservers = [ "127.0.0.1" ];

  networking.firewall = {
    allowedTCPPorts = [ 53 8000 ];
    allowedUDPPorts = [ 53 ];
  };
}
