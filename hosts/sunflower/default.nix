{
  username,
  ...
}:
let
  services = import ../../modules/nixos/services;
  pubkeys = import ../../modules/common/ssh-pubkeys.nix;
in
{
  imports = [
    ../../modules/nixos/core
    services.openssh
    services.ccpocket-bridge
    ../../profiles/nixos/wsl.nix
    ../../modules/nixos/remotebuild/builder.nix
  ];

  system.stateVersion = "25.05";
  wsl.enable = true;

  fileSystems."/" = {
    device = "/dev/sdd";
    fsType = "ext4";
  };

  nix.settings.secret-key-files = "/etc/remotebuild/cache-priv-key.pem";

  services.openssh.ports = [ 2222 ];

  mynix.profiles.userTemplates.tnmtInfo = true;

  users.users."${username}".openssh.authorizedKeys.keys = with pubkeys; [
    hosts.dahlia
    hosts.hydrangea
    # Authorize work_mac so ProxyJump via vps01 (used for the auto
    # route switch when outside the home network) can authenticate
    # directly to sunflower without relying on agent forwarding.
    hosts.work_mac
    mobile.moshiAndroid
    mobile.zfold7SshTerm
    mobile.iphone13miniSshTerm
  ];

  home-manager.users."${username}" = import ./home-manager.nix;
}
