# Hardware configuration for dahlia (AtomMan X7 Ti)
# AMD Ryzen 5 PRO 4650U, AMD Renoir GPU, 119GB NVMe
{ lib, ... }:
{
  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usb_storage"
    "sd_mod"
    "amdgpu"
  ];
  boot.kernelModules = [ "kvm-amd" ];

  # Filesystems
  # NOTE: UUIDs will change after fresh install with ext4.
  #       Run `nixos-generate-config` on the installed system
  #       and update these UUIDs accordingly.
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/CHANGEME-ROOT-UUID";
    fsType = "ext4";
  };

  fileSystems."/efi" = {
    device = "/dev/disk/by-uuid/CHANGEME-EFI-UUID";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/CHANGEME-SWAP-UUID"; }
  ];

  # GPU - AMD Renoir (Radeon Vega Series)
  hardware.graphics.enable = true;

  # CPU
  hardware.cpu.amd.updateMicrocode = lib.mkDefault true;
}
