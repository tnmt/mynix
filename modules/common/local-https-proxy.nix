# Shared option schema and CA-export helper for the local HTTPS proxy.
# OS-specific Caddy wiring lives in
# modules/{nixos,darwin}/services/local-https-proxy.nix, which import
# this file and set `caddyRootCA` to where their Caddy keeps its root CA.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mynix.services.localHttpsProxy;

  vhostType = lib.types.submodule {
    options = {
      upstream = lib.mkOption {
        type = lib.types.str;
        example = "127.0.0.1:6271";
        description = "Upstream host:port that Caddy reverse-proxies to.";
      };
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Extra Caddyfile directives appended inside the site block.";
      };
    };
  };

  exportedCAPath = "/var/lib/caddy-local-ca/root.crt";

  exportCaScript = pkgs.writeShellApplication {
    name = "local-https-proxy-export-ca";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      src=${lib.escapeShellArg cfg.caddyRootCA}
      dst=${lib.escapeShellArg exportedCAPath}
      if [ ! -r "$src" ]; then
        echo "local-https-proxy: $src is not yet present; start caddy first." >&2
        exit 1
      fi
      install -Dm0644 "$src" "$dst"
      echo "Copied Caddy local root CA to $dst"
      echo "Add it to security.pki.certificateFiles to trust it system-wide."
    '';
  };
in
{
  options.mynix.services.localHttpsProxy = {
    enable = lib.mkEnableOption "local HTTPS reverse proxy via Caddy with an internal CA";

    virtualHosts = lib.mkOption {
      type = lib.types.attrsOf vhostType;
      default = { };
      example = lib.literalExpression ''
        {
          "givy.lvh.me".upstream = "127.0.0.1:6271";
        }
      '';
      description = ''
        Map of host names to upstreams. Each host is served over HTTPS via
        Caddy's internal CA (`tls internal`).
      '';
    };

    trustedRootCAFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Pre-extracted Caddy local root CA (PEM) added to
        `security.pki.certificateFiles` so the system trust store accepts the
        internal certificates. Bootstrap with the
        `local-https-proxy-export-ca` helper after the first activation.
      '';
    };

    caddyRootCA = lib.mkOption {
      type = lib.types.str;
      internal = true;
      description = "Where Caddy keeps its internal root CA certificate (set by the OS module).";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ exportCaScript ];

    security.pki.certificateFiles = lib.mkIf (cfg.trustedRootCAFile != null) [
      cfg.trustedRootCAFile
    ];
  };
}
