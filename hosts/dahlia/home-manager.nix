{
  inputs,
  username,
  ...
}:
{
  imports = [
    ../../home-manager/base
    ../../home-manager/base/nixos-hm.nix
    ../../home-manager/devel
    ../../home-manager/desktop
    ../../home-manager/desktop/hyprland
    ../../home-manager/desktop/terminal
  ];

  custom = {
    desktop = true;
    development = true;
  };
}
