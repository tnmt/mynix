{ config, ... }:
{
  sops.templates."nginx-trusted-ips" = {
    content = ''
      allow ${config.sops.placeholder.trusted_ip_home};
      allow ${config.sops.placeholder.trusted_ip_homelab};
      allow ${config.sops.placeholder.trusted_ip_office};
      allow 100.64.0.0/10;
      deny all;
    '';
    owner = "nginx";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;

    # Status endpoint (local only)
    virtualHosts."localhost" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 8080;
        }
      ];
      locations."/nginx_status" = {
        extraConfig = ''
          stub_status on;
          access_log off;
          allow 127.0.0.1;
          deny all;
        '';
      };
    };

    # 3min.tnmt.info → redirect to tnmt.info/diary/
    virtualHosts."3min.tnmt.info" = {
      forceSSL = true;
      enableACME = true;
      locations."= /" = {
        return = "301 https://tnmt.info/diary/";
      };
      locations."= /index.rdf" = {
        return = "301 https://tnmt.info/diary/index.xml";
      };
      locations."/" = {
        return = "301 https://tnmt.info/diary/";
      };
      extraConfig = ''
        location ~ "^/(\d{4})(\d{2})(\d{2})\.html" {
          return 301 https://tnmt.info/diary/$1$2$3/;
        }
        if ($arg_date ~ "^(\d{4})(\d{2})(\d{2})$") {
          return 301 https://tnmt.info/diary/$1$2$3/;
        }
      '';
    };

    # blog.tnmt.info → redirect to tnmt.info/blog/
    virtualHosts."blog.tnmt.info" = {
      forceSSL = true;
      enableACME = true;
      locations."= /" = {
        return = "301 https://tnmt.info/blog/";
      };
      locations."= /rss/" = {
        return = "301 https://tnmt.info/blog/index.xml";
      };
      locations."/" = {
        return = "301 https://tnmt.info/blog$request_uri";
      };
      extraConfig = ''
        location ~ "^/(\d{4})/(\d{2})/(\d{2})/([^/\r\n]+)/" {
          return 301 https://tnmt.info/blog/$4/;
        }
      '';
    };

    # feeds.tnmt.info → redirect feeds
    virtualHosts."feeds.tnmt.info" = {
      forceSSL = true;
      enableACME = true;
      locations."= /blogtnmtinfo" = {
        return = "301 https://tnmt.info/blog/index.xml";
      };
      locations."= /3mintnmtinfo" = {
        return = "301 https://tnmt.info/diary/index.xml";
      };
      locations."/" = {
        return = "301 https://tnmt.info/";
      };
    };

    # mta-sts.tnmt.info → static
    virtualHosts."mta-sts.tnmt.info" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/mta-sts.tnmt.info";
      locations."/.well-known/" = {
        extraConfig = ''
          add_header 'Access-Control-Allow-Origin' '*';
        '';
      };
    };

  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
