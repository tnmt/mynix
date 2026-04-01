{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/mapper/vg0-root";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/48583a3b-97ad-4a1c-bcc9-98d14ff1a870";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/mapper/vg0-swap"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
