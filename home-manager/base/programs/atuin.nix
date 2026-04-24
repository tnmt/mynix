{ config, ... }:
let
  sopsShared = import ../../../profiles/common/sops-shared.nix;
in
{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    # settings is intentionally empty — config.toml is managed by sops.templates
    # to embed sync_address secret without activation script hacks.
  };

  sops.templates."atuin-config" = {
    content = sopsShared.mkAtuinConfigTemplate {
      syncAddressPlaceholder = config.sops.placeholder.atuin_sync_address;
    };
    path = "${config.xdg.configHome}/atuin/config.toml";
  };
}
