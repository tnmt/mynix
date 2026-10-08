{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
    # デフォルトの48kHz固定クロックだと44.1kHz系ソース(CD由来のFLAC等)が
    # 毎回48kHzにリサンプリングされる。allowed-ratesで候補を持たせることで
    # ソースのネイティブレートに合わせてグラフのクロックレートが動的に切り替わる。
    extraConfig.pipewire."99-sample-rates" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [
          44100
          48000
          88200
          96000
          176400
          192000
        ];
      };
    };
    # USB オーディオ I/F (MOTU M2) は優先度が Bluetooth より高く、接続の度に
    # 既定シンクを奪うため、自動選択の対象から後ろへ回す。手動選択は可能。
    wireplumber.extraConfig."51-motu-m2-low-priority" = {
      "monitor.alsa.rules" = [
        {
          matches = [ { "node.name" = "~alsa_output.usb-MOTU_M2.*"; } ];
          actions.update-props."priority.session" = 100;
        }
      ];
    };
  };
}
