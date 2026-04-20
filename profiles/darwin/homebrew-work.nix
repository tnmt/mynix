# Work-specific Homebrew additions for darwin hosts.
{ ... }:
{
  homebrew = {
    taps = [
      "goreleaser/tap"
      "hashicorp/tap"
      "rtk-ai/tap"
    ];
    brews = [
      "azure-cli"
      "colima"
      "consul-template"
      "docker"
      "envchain"
      "hashicorp/tap/vault"
      "rtk-ai/tap/rtk"
    ];
    casks = [
      "cmux"
      "goreleaser"
      "kiro"
      "meetingbar"
      "notion"
      "visual-studio-code"
    ];
  };
}
