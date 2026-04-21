{ systemSopsFile, ... }:
{
  users.users.nixremote = {
    isNormalUser = true;
    home = "/home/nixremote";
    group = "users";
  };

  # Authorized keys are stored encrypted in secrets/hosts/<host>.yaml
  # and materialized at activation time to the path sshd reads from by
  # default (AuthorizedKeysFile includes /etc/ssh/authorized_keys.d/%u).
  sops.secrets.nixremote_authorized_keys = {
    sopsFile = systemSopsFile;
    path = "/etc/ssh/authorized_keys.d/nixremote";
    owner = "root";
    group = "root";
    mode = "0444";
  };
}
