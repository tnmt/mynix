{ pkgs, ... }:
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
      passwordFile = "/var/lib/forgejo/db-password";
    };
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
        LFS_JWT_SECRET = "QaBgxGTn0dJvJcSvhHlK5kRHHWdpy7PFk3d52osBY3o";
        OFFLINE_MODE = true;
      };
      oauth2 = {
        JWT_SECRET = "bceZIBmkkAReKpcIvpOxeHTMbnDnwYaZ7N0X_ZDR94I";
      };
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

  networking.firewall.allowedTCPPorts = [ 2223 ];
}
