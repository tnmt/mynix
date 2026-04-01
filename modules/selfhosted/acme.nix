{ config, pkgs, ... }:
{
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
