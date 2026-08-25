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
    # This is a system service, not a --user unit, so XDG_RUNTIME_DIR is not
    # set automatically; mpd needs it to reach the user's PipeWire socket.
    XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.${username}.uid}";
  };
}
