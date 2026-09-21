# Skill 本体と API key の分離。
#
# skill definition (Nix store 上、world-readable) には key を一切含めない。
# 実体は system layer の sops で復号され、user 所有のファイルとして
# ~/.config/<app>/env に symlink される
# (profiles/common/user-sops.nix と modules/common/user-template-links.nix)。
# ここではそれを shell から読むだけなので、Nix store に平文は入らない。
_: {
  programs.zsh.envExtra = ''
    if [ -r "$HOME/.config/typesafe/env" ]; then
      . "$HOME/.config/typesafe/env"
    fi
  '';
}
