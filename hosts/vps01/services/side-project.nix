{ config, pkgs, ... }:
let
  domain = import ../../../secrets/side-project-domain.nix;
in
{
  services.phpfpm.pools.${domain} = {
    user = "nginx";
    group = "nginx";
    phpPackage = pkgs.php83;
    settings = {
      "listen" = "/run/phpfpm/${domain}.sock";
      "listen.owner" = "nginx";
      "listen.group" = "nginx";
      "pm" = "dynamic";
      "pm.max_children" = 10;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 5;
    };
  };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    root = "/var/www/${domain}";
    locations."/" = {
      tryFiles = "$uri $uri/ /index.php?$args";
      index = "index.php";
    };
    locations."~ \\.php$" = {
      extraConfig = ''
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/phpfpm/${domain}.sock;
        fastcgi_index index.php;
        include ${config.services.nginx.package}/conf/fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root/$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
      '';
    };
  };

  services.nginx.virtualHosts."www.${domain}" = {
    forceSSL = true;
    enableACME = true;
    globalRedirect = domain;
  };
}
