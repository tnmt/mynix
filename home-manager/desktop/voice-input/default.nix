{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libnotify
    (whisper-cpp.override { vulkanSupport = true; })
    wtype
    sox

    (pkgs.writeShellScriptBin "voice-input" (builtins.readFile ./scripts/voice-input))
  ];
}
