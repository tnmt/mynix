{ pkgs, ... }:
let
  icon = name: builtins.toString ./icons/${name}.png;
  tuiFloat = cmd: "${pkgs.alacritty}/bin/alacritty --class tui-float -e ${cmd}";
in
{
  xdg.desktopEntries = {
    amazon-music = {
      name = "Amazon Music";
      comment = "Amazon Music Web App";
      exec = "launch-webapp https://music.amazon.co.jp/";
      icon = icon "amazon-music";
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
      icon = icon "chatgpt";
      terminal = false;
      categories = [ "Network" ];
    };

    claude = {
      name = "Claude";
      comment = "Claude Web App";
      exec = "launch-webapp https://claude.ai/";
      icon = icon "claude";
      terminal = false;
      categories = [ "Network" ];
    };

    gemini = {
      name = "Gemini";
      comment = "Gemini Web App";
      exec = "launch-webapp https://gemini.google.com/";
      icon = icon "gemini";
      terminal = false;
      categories = [ "Network" ];
    };

    zoom = {
      name = "Zoom";
      comment = "Zoom Web App";
      exec = "launch-webapp https://app.zoom.us/wc/home";
      icon = icon "zoom";
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
