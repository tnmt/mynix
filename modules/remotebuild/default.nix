{ ... }:
{
  nix.buildMachines = [
    {
      hostName = "sunflower";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      maxJobs = 1;
      speedFactor = 2;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
      mandatoryFeatures = [ ];
    }
  ];

  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
  nix.settings.trusted-public-keys = [
    "sunflower:iq3NX80BoEVA8m/+RF2xxirVdBVkvsdE75+elmlwQAI="
    "vps03:C/1SqKVBylqziAX2hRuiCzQrNBB0Agfd/E0tu2rlXA8="
  ];
  nix.settings.trusted-substituters = [
    "ssh-ng://sunflower"
    #"ssh-ng://vps03"
  ];

  nix.settings.substituters = [
    "https://cache.nixos.org"
    "ssh-ng://sunflower"
    #"ssh-ng://vps03"
  ];
}
