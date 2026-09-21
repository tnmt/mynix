{ config, ... }:
{
  users.users.mackerel-agent = {
    isSystemUser = true;
    group = "mackerel-agent";
  };
  users.groups.mackerel-agent = { };

  sops.secrets.mackerel_api_key = { };
  sops.templates.mackerelAgentApiKey = {
    content = ''
      apikey = "${config.sops.placeholder.mackerel_api_key}"
    '';
    owner = "mackerel-agent";
    group = "mackerel-agent";
  };

  services.mackerel-agent = {
    enable = true;
    apiKeyFile = config.sops.templates.mackerelAgentApiKey.path;
  };
}
