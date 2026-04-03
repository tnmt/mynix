{ config, ... }:
{
  services.couchdb = {
    enable = true;
    bindAddress = "127.0.0.1";
    adminUser = "admin";
    adminPass = "will-be-replaced"; # placeholder, overridden by configFile
    configFile = config.sops.templates."couchdb_admin_config".path;
  };

  # Generate CouchDB config from sops secret
  sops.secrets.couchdb_admin_password = { };
  sops.templates."couchdb_admin_config" = {
    content = ''
      [admins]
      admin = ${config.sops.placeholder.couchdb_admin_password}
    '';
    owner = "couchdb";
  };

  services.nginx.virtualHosts."obsidian-sync.tnmt.info" = {
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
}
