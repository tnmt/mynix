# Shared WSL system profile for NixOS hosts running inside Windows.
{
  inputs,
  username,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl.defaultUser = username;

  # tier = "workstation" implies "this host is the LAN hub itself", so
  # self-reference sunflower blocks are skipped and LAN peers resolve
  # directly. sunflower is currently the only WSL host and also the
  # sole workstation; re-parameterise if that changes.
  profiles.userTemplates = {
    enable = true;
    voiceInput = false;
    sshPrivate = {
      role = "client";
      tier = "workstation";
    };
  };
}
