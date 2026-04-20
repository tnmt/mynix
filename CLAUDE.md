# CLAUDE.md

## セットアップ

### pre-commit フック

コミット時に `nix fmt` を自動実行する pre-commit フックを使用している。
コミット前に以下を確認し、未設定なら実行すること。

```bash
git config core.hooksPath  # .githooks と表示されればOK
git config core.hooksPath .githooks  # 未設定の場合
```

## テーマ管理

カラーテーマは `themes/` ディレクトリで一元管理している。現在のテーマは TokyoNight Storm (`themes/tokyonight-storm.nix`)。

- 各プログラム固有のテーマ名は `themes/tokyonight-storm.nix` 内にキーとして定義（例: `ghostty`, `kitty`）
- 新しいプログラムにテーマを適用する場合、ハードコードせず `theme` 変数経由で参照すること
- テーマを追加する場合は `themes/` にファイルを作り、`themes/default.nix` に登録する

### カラー定義の使い分け

- **folke/tokyonight.nvim の extras/ にテーマがある場合**、積極的にそちらを使う。`theme.extras.*` にパスを定義し、`xdg.configFile` 等で配置する
- **ベースカラー（背景/前景/ANSI 16色/アクセント）** は `themes/` を正とし、`theme.background` 等で参照する
- **アプリ固有の装飾色**（ボーダー、グラデーション、UI 要素の配色等）はアプリの設定にハードコードで構わない

## フォント管理

フォント定義は `home-manager/desktop/fonts.nix` で一元管理している。

- フォントを使うモジュールは `let fonts = import ../fonts.nix;`（パスは相対）で直接インポートする
- `_module.args` 経由では渡さない — 各モジュールが自己完結的にインポートする方針
