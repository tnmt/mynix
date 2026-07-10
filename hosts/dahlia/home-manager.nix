{
  pkgs,
  ...
}:
{
  imports = [
    # Shared desktop profile for the Hyprland workstation.
    ../../profiles/home-manager/desktop-hyprland.nix
    ../../profiles/home-manager/ssh-agent-keychain.nix
  ];

  home.packages = [
    pkgs.btrfs-progs
    pkgs.msgvault
    pkgs.symbol-desktop-wallet
  ];
}
