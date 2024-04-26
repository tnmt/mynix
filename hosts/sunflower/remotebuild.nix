{...} : {
  nix.buildMachines = [
    {
      hostName = "hydrangea";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      maxJobs = 1;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }
    {
      hostName = "maple";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      maxJobs = 1;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }
  ] ;
  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  nix.extraOptions = ''
builders-use-substitutes = true
    '';
  nix.settings.trusted-public-keys = [
  "maple:YJWnCaukPN2HZDuJtVUpyVq2szmcgkKwMEzl+fXt1DA="
  "hydrangea:3aHkYRMqxgt9I9d8lp9ow/C0oPVTUp/0OFEObz2LRkU="
  "vps03:C/1SqKVBylqziAX2hRuiCzQrNBB0Agfd/E0tu2rlXA8="
  "tnmt.cachix.org-1:TWp26nryyjLq7Xzyz7Hx81W7htBNcIMcbfHw+BrxtF8="
    ];
  nix.settings.trusted-substituters = [
    "ssh-ng://vps03"
    "ssh-ng://maple"
    "ssh-ng://hydrangea"
  ];

  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://tnmt.cachix.org"
    "ssh-ng://vps03"
    "ssh-ng://maple"
    "ssh-ng://hydrangea"
  ];

  nix.settings.trusted-users = [
    "root"
    "tnmt"
  ];
}
