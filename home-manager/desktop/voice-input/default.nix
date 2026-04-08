{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libnotify
    (whisper-cpp.override { vulkanSupport = true; })
    wtype
    sox
    jq
    curl

    (pkgs.writeShellScriptBin "voice-input" (builtins.readFile ./scripts/voice-input))
  ];
}
