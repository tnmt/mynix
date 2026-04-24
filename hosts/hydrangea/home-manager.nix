{ ... }:
{
  imports = [
    # Shared darwin user profile for development hosts.
    ../../profiles/home-manager/darwin-development.nix
  ];

  profiles.sshPrivate = {
    role = "client";
    tier = "laptop";
  };
}
