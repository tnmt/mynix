{ username, ... }:
{
  imports = [
    ../../modules/darwin/core

    # Shared macOS base configuration.
    ../../profiles/darwin/system-common.nix
    ../../profiles/darwin/homebrew-base.nix

    # Work-specific Homebrew additions.
    ../../profiles/darwin/homebrew-work.nix
  ];

  # Host-specific Home Manager entrypoint.
  home-manager.users."${username}" = import ./home-manager.nix;
}
