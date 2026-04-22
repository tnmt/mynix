{ hostname, lib, ... }:
{
  # mkDefault so profiles that defer hostname to another source
  # (e.g. cloud-init on the OpenStack profile) can clear this.
  networking.hostName = lib.mkDefault hostname;
}
