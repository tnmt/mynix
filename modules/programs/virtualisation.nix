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

  programs.virt-manager.enable = true;
  programs.dconf.enable = true;
}
