{ ... }:
{
  services.couchdb = {
    enable = true;
    bindAddress = "0.0.0.0";
  };

  networking.firewall.allowedTCPPorts = [ 5984 6984 ];
}
