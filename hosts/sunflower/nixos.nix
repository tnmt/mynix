{
  username,
  ...
}:
let
  services = import ../../modules/services;
  pubkeys = import ../../modules/common/ssh-pubkeys.nix;
in
{
  imports = [
    # Shared system roles for the WSL host.
    ../../modules/nixos/core
    services."openssh"
    services."ccpocket-bridge"
    ../../profiles/nixos/wsl.nix
    ../../modules/nixos/remotebuild/builder.nix
  ];

  # Host-local filesystem layout.
  fileSystems."/" = {
    device = "/dev/sdd";
    fsType = "ext4";
  };

  # Host-local build cache key.
  nix.settings.secret-key-files = "/etc/remotebuild/cache-priv-key.pem";

  services.openssh.ports = [ 2222 ];

  # SSH Term on zfold7 lacks ETM MAC support; allow non-ETM SHA-2 on
  # this host only. ETM variants remain preferred; sha1/md5 stay out.
  services.openssh.settings.Macs = [
    "hmac-sha2-512-etm@openssh.com"
    "hmac-sha2-256-etm@openssh.com"
    "umac-128-etm@openssh.com"
    "hmac-sha2-512"
    "hmac-sha2-256"
  ];

  users.users."${username}".openssh.authorizedKeys.keys = with pubkeys; [
    hosts.dahlia
    hosts.hydrangea
    # Authorize work_mac so ProxyJump via vps01 (used for the auto
    # route switch when outside the home network) can authenticate
    # directly to sunflower without relying on agent forwarding.
    hosts.work_mac
    hosts.zfold7
  ];

  # Host-specific Home Manager entrypoint.
  home-manager.users."${username}" = import ./home-manager.nix;
}
