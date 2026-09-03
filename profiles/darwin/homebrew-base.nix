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
      "1password"
      "1password-cli"
      "antinote"
      "appcleaner"
      "brave-origin"
      "chatgpt"
      "choosy"
      "claude"
      "dropbox"
      "element"
      "firefox"
      "ghostty"
      "google-chrome"
      "grandperspective"
      "iterm2"
      "karabiner-elements"
      "logi-options+"
      "obsidian"
      "raycast"
      "slack"
      "vimr"
      "windows-app"
      "zoom"
    ];
    # cask が存在しない Mac App Store 専売アプリ。要 App Store サインイン。
    masApps = {
      "LINE" = 539883307;
      "Reeder Classic" = 1529448980;
    };
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      # homebrew-bundle 新仕様: --cleanup は --force / --force-cleanup / $HOMEBREW_ASK のいずれか必須
      extraFlags = [ "--force-cleanup" ];
    };
  };
}
