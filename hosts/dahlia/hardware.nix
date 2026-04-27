# Hardware configuration for dahlia (ThinkPad X13 Gen1)
# AMD Ryzen 5 PRO 4650U, AMD Renoir GPU, 256GB NVMe
# Filesystems / swap are declared in ./disko.nix
{ lib, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };

    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "usb_storage"
      "sd_mod"
      "amdgpu"
    ];
    kernelModules = [ "kvm-amd" ];
    supportedFilesystems = [ "btrfs" ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    graphics.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault true;
  };
}
