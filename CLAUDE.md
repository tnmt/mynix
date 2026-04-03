# CLAUDE.md

## セットアップ

### pre-commit フック

コミット時に `nix fmt` を自動実行する pre-commit フックを使用している。
コミット前に以下を確認し、未設定なら実行すること。

```bash
git config core.hooksPath  # .githooks と表示されればOK
git config core.hooksPath .githooks  # 未設定の場合
```
