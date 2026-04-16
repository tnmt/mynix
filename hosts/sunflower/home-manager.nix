{
  ...
}:
let
  services = import ../../home-manager/services;
in
{
  imports = [
    ../../profiles/home-manager/wsl.nix
    services."obsidian-backup"
  ];
}
