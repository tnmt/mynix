{
  username,
  ...
}:
let
  services = import ../../modules/services;
in
{
  imports = [
    # Shared system roles for the WSL host.
    ../../modules/core
    services."openssh"
    services."ccpocket-bridge"
    ../../profiles/nixos/wsl.nix
  ];

  # Host-local filesystem layout.
  fileSystems."/" = {
    device = "/dev/sdd";
    fsType = "ext4";
  };

  # Host-local build cache key.
  nix.settings.secret-key-files = "/etc/remotebuild/cache-priv-key.pem";

  services.openssh.ports = [ 2222 ];

  # Host-specific Home Manager entrypoint.
  home-manager.users."${username}" = import ./home-manager.nix;
}
