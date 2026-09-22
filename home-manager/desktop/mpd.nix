{ config, ... }:
{
  # systemd --user サービスとして動かす。system service だと mpd の
  # 実行ユーザーの XDG_RUNTIME_DIR (PipeWire ソケットの場所) を手動で
  # 組み立てる必要があり、UID が自動割当 (uid オプション未指定) だと
  # 評価時に取得できず解決できない。user service ならユーザーセッションの
  # 環境がそのまま渡るのでこの問題が発生しない。
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Dropbox/Music/";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Output"
      }
    '';
  };
}
