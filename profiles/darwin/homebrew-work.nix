# Work-specific Homebrew additions for darwin hosts.
{ ... }:
{
  homebrew = {
    taps = [
      "goreleaser/tap"
      "hashicorp/tap"
      "pyama86/kagiana"
      "rtk-ai/tap"
    ];
    brews = [
      "azure-cli"
      "colima"
      "consul-template"
      "docker"
      "envchain"
      "hashicorp/tap/vault"
      "pyama86/kagiana/kagiana"
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
