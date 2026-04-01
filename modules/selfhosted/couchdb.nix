{ ... }:
{
  services.couchdb = {
    enable = true;
    bindAddress = "0.0.0.0";
    adminUser = "admin";
    adminPass = "changeme"; # TODO: replace with sops secret
  };

  networking.firewall.allowedTCPPorts = [ 5984 6984 ];
}
