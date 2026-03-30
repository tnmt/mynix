{ config, ... }:
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

  # Inject sync_address from sops secret after activation
  home.activation.atuinSyncAddress = config.lib.dag.entryAfter [ "sopsNix" ] ''
    if [ -f "${config.sops.secrets.atuin_sync_address.path}" ]; then
      ADDR=$(cat "${config.sops.secrets.atuin_sync_address.path}")
      ATUIN_CONFIG="${config.xdg.configHome}/atuin/config.toml"
      if [ -f "$ATUIN_CONFIG" ]; then
        if grep -q "^sync_address" "$ATUIN_CONFIG"; then
          sed -i "s|^sync_address.*|sync_address = \"$ADDR\"|" "$ATUIN_CONFIG"
        else
          echo "sync_address = \"$ADDR\"" >> "$ATUIN_CONFIG"
        fi
      fi
    fi
  '';
}
