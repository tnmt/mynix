_: {
  # GUI 1Password に依存しづらいセッションでも ssh-agent をシェル間で共有する。
  programs.keychain = {
    enable = true;
    keys = [ "id_ed25519" ];
    extraFlags = [ "--quiet" ];
  };
}
