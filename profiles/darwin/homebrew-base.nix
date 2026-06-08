# Base Homebrew packages shared by all darwin hosts.
_: {
  homebrew = {
    enable = true;
    taps = [
      "k1LoW/tap"
      "nikitabobko/tap"
      "takai/tap"
    ];
    brews = [
      "k1low/tap/mo"
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
