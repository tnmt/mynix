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
  # Each line has a command="nix-daemon --stdio",restrict prefix; that is
  # the primary layer of restriction (layer 1).
  sops.secrets.nixremote_authorized_keys = {
    sopsFile = systemSopsFile;
    path = "/etc/ssh/authorized_keys.d/nixremote";
    owner = "root";
    group = "root";
    mode = "0444";
  };

  # Layer 2: sshd itself enforces ForceCommand + disables TTY / forwardings
  # for this user, so even a misconfigured authorized_keys line can only
  # reach nix-daemon --stdio. Note: a nologin shell is NOT used because
  # forced commands are exec'd via the login shell (sh -c <cmd>) — nologin
  # would break ssh-ng:// remote builds.
  services.openssh.extraConfig = ''
    Match User nixremote
      ForceCommand nix-daemon --stdio
      AllowTcpForwarding no
      X11Forwarding no
      PermitTTY no
      PermitTunnel no
      AllowAgentForwarding no
  '';
}
