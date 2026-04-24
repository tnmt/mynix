# Home Manager adjustments for WSL-integrated NixOS hosts.
{ lib, pkgs, ... }:
{
  imports = [
    ./development.nix
  ];

  home.packages = [
    pkgs.wsl-open
    pkgs.wl-clipboard # WSLg の wayland 経由で tmux-yank が wl-copy 使用
  ];

  # WSLg の wayland ソケット絶対パス指定 — tmux 等に継承させる。
  home.sessionVariables = {
    WAYLAND_DISPLAY = "/mnt/wslg/runtime-dir/wayland-0";
  };

  # Local WSL セッションのみ BROWSER=wsl-open。
  # SSH 経由だと Windows ブラウザが SSH 元でなく WSL ホスト側で開くため除外。
  programs.zsh.initContent = lib.mkAfter ''
    if [ -z "$SSH_CONNECTION" ] && [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
      export BROWSER=wsl-open
    fi
  '';

  # WSL has no user systemd; secrets are managed at the NixOS system level.
  sops.secrets = lib.mkForce { };
  sops.templates = lib.mkForce { };
}
