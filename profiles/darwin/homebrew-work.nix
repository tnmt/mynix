# Work-specific Homebrew additions for darwin hosts.
_: {
  homebrew = {
    taps = [
      "goreleaser/tap"
      "rtk-ai/tap"
    ];
    brews = [
      "azure-cli"
      "colima"
      "docker"
      "envchain"
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
