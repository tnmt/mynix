{ terminal, theme, ... }:
{
  # herdr UI は GUI から設定を保存すると config-gpui.local.toml を書き換える。
  # Nix 管理にすると symlink で読み取り専用になるため、GUI 側の変更は反映されない。
  # 変えたい値はここに書くこと。terminal のフォントは Ghostty と揃える。
  xdg.configFile."herdr/config-gpui.local.toml".text = ''
    layout = "comfortable-rounded"
    remove_merged_worktrees = true
    theme = "${theme.herdr-gpui}"

    [terminal]
    family = "${terminal.font.name}"
    size = ${toString (terminal.font.size * 1.0)}

    [remote]
    enabled = true
  '';
}
