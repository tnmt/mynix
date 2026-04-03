{ config, ... }:
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

    # ***REDACTED*** uses Cloudflare DNS-01 challenge (behind Cloudflare CDN)
    certs."***REDACTED***" = {
      dnsProvider = "cloudflare";
      webroot = null;
      environmentFile = config.sops.templates."cloudflare-credentials".path;
    };
    certs."www.***REDACTED***" = {
      dnsProvider = "cloudflare";
      webroot = null;
      environmentFile = config.sops.templates."cloudflare-credentials".path;
    };
  };
}
