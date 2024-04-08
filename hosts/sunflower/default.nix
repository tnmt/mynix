{ pkgs, config, ... }: {
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];

  networking.hostName = "sunflower";
  networking.extraHosts =
		''
192.168.122.30 maple
52.195.170.108 builder
		'';

  nix.buildMachines = [ {
	  hostName = "builder";
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
		"builder:4eb0FC0PXCXRJUjKzeStqmIKP7W3Eke201vDVzyLswg=:"
	];
  nix.settings.trusted-substituters = [
    "ssh-ng://maple"
    "ssh://maple"
    "ssh-ng://builder"
    "ssh://builder"
    "ssh-ng://192.168.122.30"
    "ssh://192.168.122.30"
  ];
}
