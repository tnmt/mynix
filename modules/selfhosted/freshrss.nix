{ config, pkgs, ... }:
{
  services.phpfpm.pools.freshrss = {
    user = "nginx";
    group = "nginx";
    phpPackage = pkgs.php83;
    settings = {
      "listen" = "/run/phpfpm/freshrss.sock";
      "listen.owner" = "nginx";
      "listen.group" = "nginx";
      "pm" = "dynamic";
      "pm.max_children" = 10;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 5;
    };
  };

  services.nginx.virtualHosts."freshrss.tnmt.info" = {
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
}
