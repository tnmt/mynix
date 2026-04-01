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
      listen = [{ addr = "127.0.0.1"; port = 8080; }];
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

    # freshrss.tnmt.info → PHP app
    virtualHosts."freshrss.tnmt.info" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/freshrss/p";
      locations."/" = {
        tryFiles = "$uri $uri/ /index.php$is_args$args";
        index = "index.php index.html";
      };
      locations."~ [^/]\\.php(/|$)" = {
        extraConfig = ''
          fastcgi_pass unix:/run/phpfpm/freshrss.sock;
          fastcgi_split_path_info ^(.+?\.php)(/.*)$;
          fastcgi_param PATH_INFO $fastcgi_path_info;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
          include ${config.services.nginx.package}/conf/fastcgi_params;
          fastcgi_read_timeout 300;
        '';
      };
      locations."~ /\\." = {
        extraConfig = "deny all;";
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

    # my-wallabag.tnmt.info → PHP app
    virtualHosts."my-wallabag.tnmt.info" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/wallabag/web";
      locations."/" = {
        tryFiles = "$uri /app.php$is_args$args";
      };
      locations."~ ^/app\\.php(/|$)" = {
        extraConfig = ''
          fastcgi_pass unix:/run/phpfpm/wallabag.sock;
          fastcgi_split_path_info ^(.+\.php)(/.*)$;
          include ${config.services.nginx.package}/conf/fastcgi_params;
          fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
          fastcgi_param DOCUMENT_ROOT $realpath_root;
          internal;
        '';
      };
      locations."~ \\.php$" = {
        return = "404";
      };
    };

    # ***REDACTED*** → static + PHP (WordPress)
    virtualHosts."***REDACTED***" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/***REDACTED***";
      locations."/" = {
        tryFiles = "$uri $uri/ /index.php?$args";
        index = "index.php";
      };
      locations."~ \\.php$" = {
        extraConfig = ''
          try_files $uri =404;
          fastcgi_split_path_info ^(.+\.php)(/.+)$;
          fastcgi_pass unix:/run/phpfpm/***REDACTED***.sock;
          fastcgi_index index.php;
          include ${config.services.nginx.package}/conf/fastcgi_params;
          fastcgi_param SCRIPT_FILENAME $document_root/$fastcgi_script_name;
          fastcgi_param PATH_INFO $fastcgi_path_info;
        '';
      };
    };

    # www.***REDACTED*** → redirect to naked domain
    virtualHosts."www.***REDACTED***" = {
      forceSSL = true;
      enableACME = true;
      globalRedirect = "***REDACTED***";
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
