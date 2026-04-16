{
  pkgs,
  ...
}:
{
  imports = [
    ../../profiles/darwin/common.nix
  ];

  homebrew = {
    enable = true;
    taps = [
      "goreleaser/tap"
      "hashicorp/tap"
      "k1LoW/tap"
      "nikitabobko/tap"
      "pyama86/kagiana"
      "rtk-ai/tap"
      "takai/tap"
    ];
    brews = [
      "azure-cli"
      "colima"
      "consul-template"
      "docker"
      "envchain"
      "hashicorp/tap/vault"
      "k1low/tap/mo"
      "pyama86/kagiana/kagiana"
      "rtk-ai/tap/rtk"
      "takai/tap/git-ai-commit"
    ];
    casks = [
      "1password-cli"
      "appcleaner"
      "brave-browser"
      "chatgpt"
      "choosy"
      "claude"
      "cmux"
      "discord"
      "dropbox"
      "firefox"
      "ghostty"
      "google-chrome"
      "goreleaser"
      "iterm2"
      "karabiner-elements"
      "kiro"
      "meetingbar"
      "notion"
      "obsidian"
      "raycast"
      "slack"
      "vimr"
      "visual-studio-code"
      "zoom"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
    };
  };

}
