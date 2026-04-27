_: {
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    # settings is intentionally empty — config.toml is rendered at the
    # NixOS/darwin system layer (profiles/common/user-sops.nix) and
    # symlinked into ~/.config/atuin/ so the sync_address secret can be
    # interpolated without a per-user age key.
  };
}
