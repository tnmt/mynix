{ inputs, pkgs, config, ... }: {
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];

  nix.buildMachines = [ {
    hostName = "maple";
    system = "x86_64-linux";
    protocol = "ssh-ng";
    # if the builder supports building for multiple architectures,
    # replace the previous line by, e.g.
    # systems = ["x86_64-linux" "aarch64-linux"];
    maxJobs = 1;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
  }] ;
  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  nix.extraOptions = ''
builders-use-substitutes = true
    '';
  nix.settings.trusted-public-keys = [
  "maple:KVfcU0ZeAioZ8RD+lNMS4NAdOVZe5C4opaayPV3205s="
  "tnmt.cachix.org-1:TWp26nryyjLq7Xzyz7Hx81W7htBNcIMcbfHw+BrxtF8="
    ];
  nix.settings.trusted-substituters = [
    "ssh-ng://maple"
    "ssh://maple"
  ];

  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://tnmt.cachix.org"
  ];

  nix.settings.trusted-users = [
    "root"
    "tnmt"
  ];

  nix.settings.require-sigs = false;

  services.xremap = {
    userName = "tnmt";
    serviceMode = "user";
    config = {
       modmap = [
         {
           # CapsLock to Ctrl
           name = "CapsLock is dead";
           remap = {
             CapsLock = "Ctrl_L";
           };
         }
       ];
    };
  };

  networking.hostName = "sunflower";
}
