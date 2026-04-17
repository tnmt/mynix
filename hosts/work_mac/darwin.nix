{
  ...
}:
{
  imports = [
    # Shared macOS base configuration.
    ../../profiles/darwin/system-common.nix
    ../../profiles/darwin/homebrew-base.nix

    # Work-specific Homebrew additions.
    ../../profiles/darwin/homebrew-work.nix
  ];
}
