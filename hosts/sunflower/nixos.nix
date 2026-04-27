{
  lib,
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

  # Use host SSH key for sops; avoids /home dependency at boot time.
  # WSL profile sets age.keyFile to a /home path, so force-override.
  sops.age.keyFile = lib.mkForce null;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  services.openssh.ports = [ 2222 ];

  users.users."${username}".openssh.authorizedKeys.keys = with pubkeys; [
    hosts.dahlia
    hosts.hydrangea
    # Authorize work_mac so ProxyJump via vps01 (used for the auto
    # route switch when outside the home network) can authenticate
    # directly to sunflower without relying on agent forwarding.
    hosts.work_mac
    mobile.zfold7SshTerm
    mobile.iphone13miniSshTerm
  ];

  # Host-specific Home Manager entrypoint.
  home-manager.users."${username}" = import ./home-manager.nix;
}
