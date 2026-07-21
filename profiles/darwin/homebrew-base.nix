# Base Homebrew packages shared by all darwin hosts.
_: {
  homebrew = {
    enable = true;
    # Homebrew 6.0 から third-party tap は trust 必須 (HOMEBREW_REQUIRE_TAP_TRUST)。
    # trusted = true で Brewfile に `trusted: true` が付き、activation 時に許可される。
    taps = [
      {
        name = "nikitabobko/tap";
        trusted = true;
      }
      {
        name = "takai/tap";
        trusted = true;
      }
    ];
    brews = [
      "takai/tap/git-ai-commit"
    ];
    casks = [
      "1password-cli"
      "antinote"
      "appcleaner"
      "chatgpt"
      "choosy"
      "claude"
      "discord"
      "dropbox"
      "element"
      "firefox"
      "ghostty"
      "google-chrome"
      "iterm2"
      "karabiner-elements"
      "obsidian"
      "raycast"
      "slack"
      "vimr"
      "zoom"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      # homebrew-bundle 新仕様: --cleanup は --force / --force-cleanup / $HOMEBREW_ASK のいずれか必須
      extraFlags = [ "--force-cleanup" ];
    };
  };
}
