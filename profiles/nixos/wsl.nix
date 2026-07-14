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

  # WSL2 で nixpkgs 版 opencode (Bun単一バイナリ + autoPatchelf) が SIGSEGV する。
  # 回避策: 公式インストーラ (curl https://opencode.ai/install) で導入する
  # generic ELF を nix-ld 経由で実行する。
  programs.nix-ld.enable = true;

  # tier = "workstation" implies "this host is the LAN hub itself", so
  # self-reference sunflower blocks are skipped and LAN peers resolve
  # directly. sunflower is currently the only WSL host and also the
  # sole workstation; re-parameterise if that changes.
  mynix.profiles.userTemplates = {
    enable = true;
    voiceInput = false;
    sshPrivate = {
      role = "client";
      tier = "workstation";
    };
  };
}
