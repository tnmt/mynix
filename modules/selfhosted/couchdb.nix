{ config, ... }:
{
  services.couchdb = {
    enable = true;
    bindAddress = "0.0.0.0";
    adminUser = "admin";
    adminPass = "will-be-replaced"; # placeholder, overridden by configFile
    configFile = "/run/secrets/couchdb_admin_config";
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

  networking.firewall.allowedTCPPorts = [ 5984 6984 ];
}
