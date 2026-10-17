{
  pkgs,
  ...
}:
{
  imports = [
    # Shared desktop profile for the Hyprland workstation.
    ../../profiles/home-manager/desktop-hyprland.nix
    ../../profiles/home-manager/ssh-agent-keychain.nix
    # Dahlia 固有: ProtonMail Bridge を systemd user service として常駐
    ../../home-manager/desktop/protonmail-bridge.nix
    ../../home-manager/desktop/mpd.nix
    ../../home-manager/desktop/euphonica.nix
    ../../home-manager/desktop/proton-drive-backup.nix
    ../../home-manager/devel/kiseki.nix
  ];

  services.kiseki-agent.browserHistory.browsers = [ "brave-origin" ];
  services.kiseki-agent.browserHistory.excludeProfiles = [ "brave-origin/Profile 4" ];

  # SSH 経由のシェルから noctalia msg 等で Hyprland セッションを操作するため。
  # ssh host cmd のような非対話実行でも効くよう .zshenv に置く。
  programs.zsh.envExtra = ''
    if [[ -n "$SSH_CONNECTION" ]]; then
      export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
      export WAYLAND_DISPLAY="''${WAYLAND_DISPLAY:-wayland-1}"
    fi
  '';

  programs.zsh.shellAliases.lock = "noctalia msg session lock";

  home.packages = [
    pkgs.btrfs-progs
    # 4K/1.25 倍の DP-1 で既定の文字が小さいため Chromium 側で拡大する
    (pkgs.symlinkJoin {
      name = "chatgpt-scaled";
      inherit (pkgs.chatgpt) meta;
      paths = [ pkgs.chatgpt ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/chatgpt --add-flags "--force-device-scale-factor=1.75"
      '';
    })
    pkgs.msgvault
    pkgs.symbol-desktop-wallet
  ];
}
