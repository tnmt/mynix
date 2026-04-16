{
  ...
}:
let
  services = import ../../home-manager/services;
in
{
  imports = [
    # Shared WSL-oriented Home Manager profile.
    ../../profiles/home-manager/wsl.nix

    # Host-local user services.
    services."obsidian-backup"
  ];
}
