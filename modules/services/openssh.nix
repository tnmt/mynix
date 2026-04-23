{
  config,
  lib,
  username,
  ...
}:
let
  pubkeys = import ../common/ssh-pubkeys.nix;
  authorizedHostKeys =
    lib.attrByPath
      [
        "users"
        "users"
        username
        "openssh"
        "authorizedKeys"
        "keys"
      ]
      [ ]
      config;
in
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = lib.mkDefault false;
      KbdInteractiveAuthentication = lib.mkDefault false;
      PermitRootLogin = lib.mkDefault "no";
      X11Forwarding = lib.mkDefault false;
      MaxAuthTries = lib.mkDefault 3;
      ClientAliveInterval = lib.mkDefault 300;
      ClientAliveCountMax = lib.mkDefault 2;

      # Defense-in-depth: pin the auth method explicitly even though
      # PasswordAuthentication / KbdInteractiveAuthentication are off.
      AuthenticationMethods = lib.mkDefault "publickey";

      # Tighten the brute-force window (default 120s).
      LoginGraceTime = lib.mkDefault 30;

      # Log the public key fingerprint used for each auth attempt so
      # fail2ban / forensics can correlate by key, not just IP.
      LogLevel = lib.mkDefault "VERBOSE";
    };
  };

  # SSH Term on zfold7 lacks ETM MAC support. If this host authorizes
  # pubkeys.hosts.zfold7, keep ETM variants preferred but allow non-ETM
  # SHA-2 too.
  services.openssh.settings.Macs = lib.mkIf (builtins.elem pubkeys.hosts.zfold7 authorizedHostKeys) [
    "hmac-sha2-512-etm@openssh.com"
    "hmac-sha2-256-etm@openssh.com"
    "umac-128-etm@openssh.com"
    "hmac-sha2-512"
    "hmac-sha2-256"
  ];
}
