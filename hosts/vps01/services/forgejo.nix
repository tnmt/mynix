{ config, pkgs, ... }:
{
  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;
    database = {
      type = "mysql";
      host = "127.0.0.1";
      port = 3306;
      name = "forgejo";
      user = "forgejo";
      passwordFile = config.sops.secrets.forgejo_db_password.path;
    };
    secrets.server.LFS_JWT_SECRET = config.sops.secrets.forgejo_lfs_jwt_secret.path;
    settings = {
      DEFAULT = {
        APP_NAME = "git.tnmt.info";
      };
      server = {
        DOMAIN = "git.tnmt.info";
        ROOT_URL = "https://git.tnmt.info/";
        HTTP_PORT = 3000;
        SSH_DOMAIN = "git.tnmt.info";
        SSH_PORT = 2223;
        START_SSH_SERVER = true;
        SSH_LISTEN_PORT = 2223;
        LFS_START_SERVER = true;
        OFFLINE_MODE = true;
      };
      oauth2 = { };
      service = {
        DISABLE_REGISTRATION = true;
        REQUIRE_SIGNIN_VIEW = true;
      };
      session = {
        PROVIDER = "file";
      };
      log = {
        LEVEL = "Info";
      };
      repository = {
        DEFAULT_BRANCH = "main";
      };
      "repository.pull-request" = {
        DEFAULT_MERGE_STYLE = "merge";
      };
      "repository.signing" = {
        DEFAULT_TRUST_MODEL = "committer";
      };
      security = {
        INSTALL_LOCK = true;
        PASSWORD_HASH_ALGO = "pbkdf2_hi";
      };
      mailer = {
        ENABLED = false;
      };
    };
  };

  services.nginx.virtualHosts."git.tnmt.info" = {
    forceSSL = true;
    enableACME = true;
    extraConfig = ''
      client_max_body_size 512M;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
      extraConfig = ''
        proxy_read_timeout 600;
      '';
    };
  };

  sops.secrets.forgejo_lfs_jwt_secret = {
    owner = "forgejo";
  };
  sops.secrets.forgejo_db_password = {
    owner = "forgejo";
  };

  networking.firewall.allowedTCPPorts = [ 2223 ];
}
