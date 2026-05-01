{ pkgs, ... }:
let
  benchPython = pkgs.python3.withPackages (ps: [ ps.jiwer ]);
in
{
  home.packages = with pkgs; [
    libnotify
    (whisper-cpp.override { vulkanSupport = true; })
    wtype
    sox
    jq
    curl
    bc
    benchPython

    (pkgs.writeShellScriptBin "voice-input" (builtins.readFile ./scripts/voice-input))
    (pkgs.writeShellScriptBin "voice-input-bench" (builtins.readFile ./scripts/voice-input-bench))
  ];
}
