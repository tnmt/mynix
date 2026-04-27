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

  profiles.sshPrivate = {
    role = "client";
    tier = "laptop";
  };

  home.packages = [ pkgs.btrfs-progs ];
}
