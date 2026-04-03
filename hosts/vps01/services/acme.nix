{ config, ... }:
let
  domain = import ../../../secrets/side-project-domain.nix;
in
{
  sops.secrets.cloudflare_api_key = { };
  sops.secrets.cloudflare_email = { };
  sops.templates."cloudflare-credentials" = {
    content = ''
      CLOUDFLARE_EMAIL=${config.sops.placeholder.cloudflare_email}
      CLOUDFLARE_API_KEY=${config.sops.placeholder.cloudflare_api_key}
    '';
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "s@tnmt.info";

    # side-project uses Cloudflare DNS-01 challenge (behind Cloudflare CDN)
    certs.${domain} = {
      dnsProvider = "cloudflare";
      webroot = null;
      environmentFile = config.sops.templates."cloudflare-credentials".path;
    };
    certs."www.${domain}" = {
      dnsProvider = "cloudflare";
      webroot = null;
      environmentFile = config.sops.templates."cloudflare-credentials".path;
    };
  };
}
