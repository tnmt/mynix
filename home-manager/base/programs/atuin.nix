{ config, ... }:
{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    # settings is intentionally empty — config.toml is managed by sops.templates
    # to embed sync_address secret without activation script hacks.
  };

  sops.templates."atuin-config" = {
    content = ''
      auto_sync = true
      sync_frequency = "20m"
      search_mode = "fuzzy"
      filter_mode = "global"
      inline_height = 20
      enter_accept = false
      sync_address = "${config.sops.placeholder.atuin_sync_address}"
    '';
    path = "${config.xdg.configHome}/atuin/config.toml";
  };
}
