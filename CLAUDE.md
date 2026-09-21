# CLAUDE.md

## セットアップ

### pre-commit フック

コミット時に `nix fmt`・`deadnix`/`statix`・`gitleaks protect` を自動実行する pre-commit フックを使用している。
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

## 自作パッケージ

自作パッケージは [nur-tnmt](https://github.com/tnmt/nur-packages) input を直接参照する overlay で提供している（NUR アグリゲータは経由しない）。

- パッケージを追加・削除する場合は `lib/default.nix` の overlay 内 `inherit` リストを編集する
- flake の `packages` 出力ではなく NUR 規約の `default.nix { pkgs }` でインポートし、ホストの pkgs（allowUnfree 等の config と overlay 込み）で評価する

## AI agent tooling

`home-manager/devel/ai/` で AI coding agent 向けの構成をレイヤーごとに分けている。開発機向けなので `home-manager/base` ではなく `home-manager/devel` に置く（サーバーは `base-nixos` だけを import する）。

| ファイル | 責務 |
| --- | --- |
| `packages.nix` | CLI 本体 (ax / rtk / codex / claude-code / ccusage) |
| `skills.nix` | Agent Skill の配置 |
| `integrations.nix` | agent 固有の hook / instructions 生成 (RTK) |
| `secrets.nix` | skill から分離した API key の読み込み |

- Agent Skill の共通配置先は `~/.agents/skills/<name>`。まだ `~/.agents` を読まない agent には、同じ Nix store path への symlink を agent 固有ディレクトリ (`~/.claude/skills/<name>`) にも張る。skill の実体は store 上に 1 つだけ。
- skill の source は flake input で pin する。ax のように CLI と skill が同じ repository にある場合は input を 1 つにして revision を一致させる。
- skill を追加する前に、その repository がベンダー自身の org かを確認する。ベンダーのドメインに似た第三者サイトが、自前の課金プロキシへ API key を送らせる skill を配布している例がある（`codaaiteam/jev-skill` → `jevtypesafeai.com`）。公式は `typesafe-ai/skills`。
- プロジェクト固有の skill はここに入れず、各 repository の `.agents/skills` で管理する。
- RTK のように agent の hook/instructions を書き換える installer を持つツールは、生成物を Nix にコピーせず activation から pin した本体を idempotent に実行する。生成先のパス (`$CODEX_HOME/AGENTS.md` 等) を `home.file` で管理すると衝突するので管理しないこと。
- API key は skill definition に入れない。system layer の sops で復号し `~/.config/<app>/env` へ symlink したものを shell から source する。

## Private flake input

`shizuku` のような private リポジトリの input は CI ランナーから fetch できない。

- CI の build/eval では `.github/ci-stubs/` 配下のスタブ flake を `--override-input` で差し替えている
- private input を追加する場合は、同様にスタブを用意して `.github/workflows/ci.yml` の全対象ジョブに override を追加すること
