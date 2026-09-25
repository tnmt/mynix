{
  # gsr-kms-server に cap_sys_admin を setcap し、pkexec 経由の
  # root 認証プロンプトなしで screen-record スクリプトが動くようにする。
  programs.gpu-screen-recorder.enable = true;
}
