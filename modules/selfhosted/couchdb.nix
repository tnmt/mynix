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
  sops.secrets.couchdb_admin_password = {};
  sops.templates."couchdb_admin_config" = {
    content = ''
      [admins]
      admin = ${config.sops.placeholder.couchdb_admin_password}
    '';
    owner = "couchdb";
  };

  # 5984/6984 are not exposed directly; nginx handles SSL termination
  # Port 6984 is available via nginx reverse proxy with ACME cert
}
