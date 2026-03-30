{ ... }:
{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      auto_sync = true;
      sync_frequency = "20m";
      search_mode = "fuzzy";
      filter_mode = "global";
      inline_height = 20;
      enter_accept = false;
    };
  };
}
