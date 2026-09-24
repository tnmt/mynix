{ pkgs, ... }:
let
  tuiFloat = cmd: "${pkgs.alacritty}/bin/alacritty --class tui-float -e ${cmd}";
in
{
  xdg.desktopEntries = {
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
        "AudioVideo"
        "Audio"
        "Mixer"
      ];
    };
  };
}
