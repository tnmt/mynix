{
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
        daemon.settings = {
          dns = [
            "1.1.1.1"
            "8.8.8.8"
          ];
        };
      };
    };

    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
  };

  # swtpm_setup が swtpm-localca CA state を作るディレクトリ。
  # tss ユーザーは /var/lib 直下に書けないため、NixOS 側で用意しないと
  # 初回 VM 起動時に "Permission denied" で swtpm が失敗する。
  systemd.tmpfiles.rules = [
    "d /var/lib/swtpm-localca 0750 tss root - -"
  ];

  programs.virt-manager.enable = true;
  programs.dconf.enable = true;
}
