{ terminal, theme, ... }:
let
  fonts = import ../desktop/fonts.nix;
in
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
    # fallback を指定すると Nerd Font の自動フォールバックは効かなくなるが、
    # 主フォントの MesloLGS NF が Nerd Font なのでアイコンは出る。
    fallback = [ "${fonts.sans}" ]

    [remote]
    enabled = true
  '';
}
