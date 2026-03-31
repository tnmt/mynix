# Hardware configuration for dahlia (ThinkPad X13 Gen1)
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
    device = "/dev/disk/by-uuid/9a75e7f7-cd89-4e04-a13e-f51f2289909f";
    fsType = "ext4";
  };

  fileSystems."/efi" = {
    device = "/dev/disk/by-uuid/4AEC-514E";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/0568ef41-b667-4dcb-893a-a5f7d7b0899f"; }
  ];

  # GPU - AMD Renoir (Radeon Vega Series)
  hardware.graphics.enable = true;

  # CPU
  hardware.cpu.amd.updateMicrocode = lib.mkDefault true;
}
