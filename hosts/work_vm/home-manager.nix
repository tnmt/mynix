# Home Manager entrypoint for the work OpenStack dev VM.
{ ... }:
{
  imports = [
    ../../profiles/home-manager/work.nix
  ];

  # Receive-only dev VM: no need to render ~/.ssh/conf.d/private.config here.
  profiles.sshPrivate.enable = false;
}
