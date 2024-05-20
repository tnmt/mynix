{ config, username, ... }:
{
  services.mpd = {
    enable = true;
    user = username;
    musicDirectory = "/home/${username}/Music/";
    network.listenAddress = "any";
    startWhenNeeded = true;
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Output"
      }
    '';
  };

  systemd.services.mpd.environment = {
    # User-id must match above user
    XDG_RUNTIME_DIR = "/run/user/1000";
  };
}
