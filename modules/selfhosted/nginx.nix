{ config, ... }:
{
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

    # atuin.tnmt.info → proxy to atuin server
    virtualHosts."atuin.tnmt.info" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8888";
        proxyWebsockets = true;
      };
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

    # git.tnmt.info → Forgejo
    virtualHosts."git.tnmt.info" = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        client_max_body_size 512M;
      '';
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        extraConfig = ''
          proxy_read_timeout 600;
        '';
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

    # obsidian-sync.tnmt.info → CouchDB (Obsidian LiveSync)
    virtualHosts."obsidian-sync.tnmt.info" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:5984";
        proxyWebsockets = true;
        extraConfig = ''
          # CORS for Obsidian LiveSync
          if ($request_method = 'OPTIONS') {
            add_header 'Access-Control-Allow-Origin' $http_origin always;
            add_header 'Access-Control-Allow-Credentials' 'true' always;
            add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS, HEAD' always;
            add_header 'Access-Control-Allow-Headers' 'Accept, Authorization, Content-Type, Origin, Referer, X-Requested-With' always;
            add_header 'Access-Control-Max-Age' 3600;
            add_header 'Content-Type' 'text/plain; charset=utf-8';
            add_header 'Content-Length' 0;
            return 204;
          }
          add_header 'Access-Control-Allow-Origin' $http_origin always;
          add_header 'Access-Control-Allow-Credentials' 'true' always;
          add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS, HEAD' always;
          add_header 'Access-Control-Allow-Headers' 'Accept, Authorization, Content-Type, Origin, Referer, X-Requested-With' always;
          add_header 'Access-Control-Expose-Headers' 'Content-Type, Content-Length, ETag, X-Couch-Request-ID, X-Couch-Update-NewRev' always;
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
