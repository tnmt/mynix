{
  config,
  lib,
  pkgs,
  ...
}:
let
  benchPython = pkgs.python3.withPackages (ps: [ ps.jiwer ]);
  whisperCpp = pkgs.whisper-cpp.override { vulkanSupport = true; };
  modelDir = "${config.xdg.dataHome}/whisper-models";
  modelPath = "${modelDir}/ggml-medium.bin";
  modelUrl = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-medium.bin";

  ensureModel = pkgs.writeShellApplication {
    name = "voice-input-ensure-model";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.curl
    ];
    text = ''
      model=${lib.escapeShellArg modelPath}
      model_dir=${lib.escapeShellArg modelDir}
      model_url=${lib.escapeShellArg modelUrl}

      if [[ -f "$model" ]]; then
        exit 0
      fi

      install -d -m 700 "$model_dir"
      temporary=$(mktemp "$model.tmp.XXXXXX")
      trap 'rm -f "$temporary"' EXIT
      curl --fail --location --output "$temporary" "$model_url"
      chmod 600 "$temporary"
      mv "$temporary" "$model"
      trap - EXIT
    '';
  };

  voiceInput = pkgs.writeShellApplication {
    name = "voice-input";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.curl
      pkgs.jq
      pkgs.libnotify
      pkgs.sox
      pkgs.systemd
      pkgs.wtype
    ];
    text = ''
      export VOICE_INPUT_MODEL=${lib.escapeShellArg modelPath}
      ${builtins.readFile ./scripts/voice-input}
    '';
  };

  voiceInputBench = pkgs.writeShellApplication {
    name = "voice-input-bench";
    runtimeInputs = [
      benchPython
      pkgs.bc
      pkgs.coreutils
      pkgs.gnused
      pkgs.sox
      whisperCpp
    ];
    text = builtins.readFile ./scripts/voice-input-bench;
  };
in
{
  home.packages = [
    voiceInput
    voiceInputBench
  ];

  # Started on demand by the voice-input command so the model remains warm
  # without delaying login or consuming GPU memory before first use.
  systemd.user.services.voice-input-whisper = {
    Unit.Description = "Lazy voice-input Whisper server";
    Service = {
      Type = "simple";
      ExecStartPre = "${ensureModel}/bin/voice-input-ensure-model";
      ExecStart = "${whisperCpp}/bin/whisper-server -m ${modelPath} -l ja --port 8080 -nt";
      Restart = "on-failure";
      RestartSec = 3;
      TimeoutStartSec = "30min";
    };
  };
}
