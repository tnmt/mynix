{
  username,
  ...
}:
let
  services = import ../../modules/services;
in
{
  imports = [
    ../../modules/core
    services.openssh
    services."ccpocket-bridge"
    ../../profiles/nixos/wsl.nix
  ];

  fileSystems."/" = {
    device = "/dev/sdd";
    fsType = "ext4";
  };

  nix.settings.secret-key-files = "/etc/remotebuild/cache-priv-key.pem";

  services.openssh.ports = [ 2222 ];
  home-manager.users."${username}" = import ./home-manager.nix;
}
