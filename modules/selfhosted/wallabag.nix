{ config, pkgs, ... }:
{
  services.phpfpm.pools.wallabag = {
    user = "nginx";
    group = "nginx";
    phpPackage = pkgs.php83;
    settings = {
      "listen" = "/run/phpfpm/wallabag.sock";
      "listen.owner" = "nginx";
      "listen.group" = "nginx";
      "pm" = "dynamic";
      "pm.max_children" = 10;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 5;
    };
  };

  services.nginx.virtualHosts."my-wallabag.tnmt.info" = {
    forceSSL = true;
    enableACME = true;
    root = "/var/www/wallabag/web";
    locations."/" = {
      tryFiles = "$uri /app.php$is_args$args";
    };
    locations."~ \\.php$" = {
      extraConfig = ''
        fastcgi_pass unix:/run/phpfpm/wallabag.sock;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include ${config.services.nginx.package}/conf/fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT $realpath_root;
      '';
    };
  };
}
