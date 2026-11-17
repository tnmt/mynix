# https://codeberg.org/wvhulle/bootvine
# NixOS 26.05 以降は initrd が systemd のみなので、initrd 段階から表示される。
# LUKS のパスフレーズ要求(TPM2 で解錠できなかった場合)は bootvine が受けて表示する。
{ inputs, ... }:
{
  imports = [ "${inputs.bootvine}/nix/nixos-module.nix" ];

  services.bootvine.enable = true;
}
