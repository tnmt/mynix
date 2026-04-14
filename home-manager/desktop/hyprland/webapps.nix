{ pkgs, ... }:
let
  fetchFavicon =
    domain: name: hash:
    builtins.toString (
      pkgs.fetchurl {
        url = "https://www.google.com/s2/favicons?domain=${domain}&sz=128";
        name = "${name}-icon.png";
        inherit hash;
      }
    );

  tuiFloat = cmd: "${pkgs.alacritty}/bin/alacritty --class tui-float -e ${cmd}";
in
{
  xdg.desktopEntries = {
    amazon-music = {
      name = "Amazon Music";
      comment = "Amazon Music Web App";
      exec = "launch-webapp https://music.amazon.co.jp/";
      icon =
        fetchFavicon "music.amazon.co.jp" "amazon-music"
          "sha256-9RKGPm7JTy3vzzqnBQjITtcWZVvyuUze6Ms/rzMRCSc=";
      terminal = false;
      categories = [
        "Audio"
        "Music"
      ];
    };

    chatgpt = {
      name = "ChatGPT";
      comment = "ChatGPT Web App";
      exec = "launch-webapp https://chatgpt.com/";
      icon = fetchFavicon "chatgpt.com" "chatgpt" "sha256-kbYOlSqwmYks6+g2l5V+zg+aDz6KllM7QStI/KmH7Yk=";
      terminal = false;
      categories = [ "Network" ];
    };

    claude = {
      name = "Claude";
      comment = "Claude Web App";
      exec = "launch-webapp https://claude.ai/";
      icon = fetchFavicon "claude.ai" "claude" "sha256-AWqC8d5172Kt+sCI2h4Qzu9NjmWBPicmxzCKdVBw3Xw=";
      terminal = false;
      categories = [ "Network" ];
    };

    gemini = {
      name = "Gemini";
      comment = "Gemini Web App";
      exec = "launch-webapp https://gemini.google.com/";
      icon =
        fetchFavicon "gemini.google.com" "gemini"
          "sha256-IezRXZPMIZhpImrxwTyUUBZjY0+Y7LDRki82nvUfkc4=";
      terminal = false;
      categories = [ "Network" ];
    };

    zoom = {
      name = "Zoom";
      comment = "Zoom Web App";
      exec = "launch-webapp https://app.zoom.us/wc/home";
      icon = fetchFavicon "zoom.us" "zoom" "sha256-FtJJln9Q4USibHTf/3FIRMyhyRx+eK4fMOCD/4XAJDQ=";
      terminal = false;
      categories = [ "Network" ];
    };

    btop = {
      name = "btop++";
      genericName = "System Monitor";
      comment = "Resource monitor that shows usage and stats for processor, memory, disks, network and processes";
      exec = tuiFloat "btop";
      icon = "btop";
      terminal = false;
      categories = [
        "System"
        "Monitor"
        "ConsoleOnly"
      ];
    };

    wiremix = {
      name = "Wiremix";
      comment = "PipeWire TUI mixer";
      exec = tuiFloat "wiremix -v output";
      icon = "audio-volume-high";
      terminal = false;
      categories = [
        "Audio"
        "Mixer"
      ];
    };
  };
}
