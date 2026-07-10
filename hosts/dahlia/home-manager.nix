{
  pkgs,
  ...
}:
{
  imports = [
    # Shared desktop profile for the Hyprland workstation.
    ../../profiles/home-manager/desktop-hyprland.nix
    ../../profiles/home-manager/ssh-agent-keychain.nix
    # Dahlia 固有: ProtonMail Bridge を systemd user service として常駐
    ../../home-manager/desktop/protonmail-bridge.nix
  ];

  home.packages = [
    pkgs.btrfs-progs
    pkgs.msgvault
    pkgs.symbol-desktop-wallet
  ];
}
