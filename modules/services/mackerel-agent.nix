{ config, ... }:
{
  sops.secrets.mackerel_api_key = { };
  sops.templates."mackerel-agent-apikey" = {
    content = ''
      apikey = "${config.sops.placeholder.mackerel_api_key}"
    '';
  };

  services.mackerel-agent = {
    enable = true;
    apiKeyFile = config.sops.templates."mackerel-agent-apikey".path;
  };
}
