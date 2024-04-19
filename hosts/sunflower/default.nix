{ ... }: {
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
    ./lanzaboote.nix
  ];

  #microsoft-surface.surface-control.enable = true;

  users.users.tnmt.extraGroups = [
    "networkmanager"
    "wheel"
    "docker"
    #"surface-control"
  ];

  nix.buildMachines = [ {
    hostName = "vps";
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
  "vps:IVuoJ9xuT7nqCtwo5C1WSZOFBRxwTG3GduKCEwz/sSE="
  "tnmt.cachix.org-1:TWp26nryyjLq7Xzyz7Hx81W7htBNcIMcbfHw+BrxtF8="
    ];
  nix.settings.trusted-substituters = [
    "ssh-ng://vps"
    "ssh://vps"
  ];

  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://tnmt.cachix.org"
    "ssh-ng://vps"
    "ssh://vps"
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
