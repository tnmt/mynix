{
  ...
}:
{
  imports = [
    # Shared WSL-oriented Home Manager profile.
    ../../profiles/home-manager/wsl.nix
    ../../profiles/home-manager/ssh-agent-keychain.nix
  ];

  # sunflower = LAN hub. The actual private.config is emitted at the
  # NixOS system level by profiles/nixos/wsl.nix (WSL has no user
  # systemd). This declaration is retained so the option axes stay
  # populated if the home-manager override is ever lifted.
  profiles.sshPrivate = {
    role = "client";
    tier = "workstation";
  };

}
