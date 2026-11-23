# Shared WSL system profile for NixOS hosts running inside Windows.
{
  inputs,
  pkgs,
  username,
  ...
}:
let
  runtimeDirView = "/run/user-systemd";
  bindRuntimeDir = pkgs.writeShellScript "bind-user-runtime-dir" ''
    set -eu
    mkdir -p ${runtimeDirView}/"$1"
    ${pkgs.util-linux}/bin/mount --bind /run/user/"$1" ${runtimeDirView}/"$1"
    ${pkgs.util-linux}/bin/mount --make-private ${runtimeDirView}/"$1"
  '';
  unbindRuntimeDir = pkgs.writeShellScript "unbind-user-runtime-dir" ''
    ${pkgs.util-linux}/bin/umount --lazy ${runtimeDirView}/"$1" || true
    rmdir ${runtimeDirView}/"$1" 2>/dev/null || true
  '';
in
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl.defaultUser = username;

  # WSL2 で nixpkgs 版 opencode (Bun単一バイナリ + autoPatchelf) が SIGSEGV する。
  # 回避策: 公式インストーラ (curl https://opencode.ai/install) で導入する
  # generic ELF を nix-ld 経由で実行する。
  programs.nix-ld.enable = true;

  # WSLg は logind が作った /run/user/<uid> の上に別の tmpfs を被せるため、
  # user manager の bus と systemd/private が隠れて `systemctl --user` や
  # switch 時の user unit reload が失敗する。被せられる前に下層を
  # /run/user-systemd/<uid> へ bind しておき、上層から参照できるようにする。
  # /run/user は shared propagation なので、bind 側を private にしないと
  # WSLg のマウントが伝播して bind 側も隠れる。
  systemd.services."user-runtime-dir@".serviceConfig = {
    ExecStartPost = "-${bindRuntimeDir} %i";
    ExecStopPost = "-${unbindRuntimeDir} %i";
  };

  # 上層は WSL がセッション開始時に作るので、systemd unit からは作成を
  # 検知できない。シェル起動時に毎回リンクの有無を確かめて張る。
  environment.shellInit = ''
    if [ -n "''${UID:-}" ] && [ -d "${runtimeDirView}/$UID" ] && [ -w "/run/user/$UID" ]; then
      for __name in bus systemd; do
        if [ ! -e "/run/user/$UID/$__name" ] && [ -e "${runtimeDirView}/$UID/$__name" ]; then
          ln -sfn "${runtimeDirView}/$UID/$__name" "/run/user/$UID/$__name"
        fi
      done
      unset __name
    fi
  '';

  # libdbus は $XDG_RUNTIME_DIR/bus を lstat で検査するのでシンボリックリンクでは
  # 接続できず、switch の user unit reload が失敗する。activation は root で
  # user unit reload より前に走るため、ここで下層のソケットを上層へ bind する。
  # 上層を umount しないのは、上層にしかないソケット (cc-socks 等) を
  # 使っている実行中のプロセスを壊すため。
  system.activationScripts.wslUserBus.text = ''
    for view in ${runtimeDirView}/*; do
      [ -S "$view/bus" ] || continue
      rt=/run/user/''${view##*/}
      [ -d "$rt" ] || continue
      if [ -S "$rt/bus" ] && [ ! -L "$rt/bus" ]; then
        continue
      fi
      rm -f "$rt/bus"
      : > "$rt/bus"
      ${pkgs.util-linux}/bin/mount --bind "$view/bus" "$rt/bus" \
        || echo "warning: failed to expose $view/bus at $rt/bus" >&2
    done
  '';

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
