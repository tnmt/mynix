# Home Manager entrypoint for the work OpenStack dev VM.
{ ... }:
{
  imports = [
    ../../profiles/home-manager/work.nix
  ];

  # Receive-only dev VM: no outbound jump config, no private.config.
  profiles.sshPrivate.role = "server";
}
