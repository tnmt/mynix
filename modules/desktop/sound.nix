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
  };
}
