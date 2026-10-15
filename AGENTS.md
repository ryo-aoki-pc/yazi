# AGENTS.md

このリポジトリで作業するコーディングエージェント（Claude Code・Codex・Grok Build・Antigravity CLI）への指示。Claude Code は CLAUDE.md の `@AGENTS.md` で、Codex・Grok Build・Antigravity CLI はこのファイルを直接読む。

利用者への回答・質問・報告は、常に日本語で書く（コードのコメントなどの言語は、このファイルのほかの決まりに従う）。

## 導入手順の正本

Windows 11・AlmaLinux 10 の導入・利用・更新・任意操作は、setup-notes の [windows-setup.md](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/windows-setup.md) と [almalinux-setup.md](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/almalinux-setup.md) に集約する。既存の手順も対象とする。

- 固有の仕様・他 OS の手順・開発者検査・理由・注意・検証記録・ロールバックが残る文書は保持する
- 案内だけになった旧文書は削除する。README から上の2冊と[集約対応表](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/dev/consolidation-map.md)へ案内する

文書規則は、Windows・AlmaLinux の実行手順には上の正本へ適用する。操作や移動先を変えたら正本・README・集約対応表・参照情報を同期し、過去の検証本文は保持する。共通 bash 設定が読むツールの初期化を `~/.bashrc` に直接追記しない。

## このリポジトリは何か

[yazi](https://github.com/sxyazi/yazi)（端末のファイルマネージャー）の自分用の設定。Linux / macOS は `~/.config/yazi`、Windows は `%APPDATA%\yazi\config` に `custom` を clone して使う。使い方は [README.md](README.md)、構成と独自のキーは [docs/reference/readme.md](docs/reference/readme.md)、検証記録は [docs/verification/readme.md](docs/verification/readme.md)。

ドキュメント・コミットメッセージ・Pull Request の説明は日本語で書く。

### ブランチ構成

| ブランチ | 内容 |
| --- | --- |
| `custom` | 実際に使う設定（既定のブランチ）。`main` の上に自分の変更を rebase で載せている。作業はここから始める |
| `main` | 上流の既定の設定（`yazi-config/preset/`）そのもの。手で編集しない。作業ツリーで checkout もしない |

- 4 つの `*.toml` は、上流の既定の設定を丸ごと置いたうえで、変えたい箇所だけを編集する。自分の変更は `git diff main custom -- '*.toml'` で見る
- 上流の新しい版への追従は、`bash scripts/update-upstream.sh` で `main` にコミットを積み、`git rebase main custom` で載せ替える（README の「上流の新しい版に追従する」）

## 構成

- `yazi.toml`・`keymap.toml`・`theme.toml`・`vfs.toml` — 設定（上流のファイル名との対応は `docs/reference/readme.md`）
- `init.lua` — 行表示モード `size_and_mtime`
- `plugins/smart-enter.yazi/` — `l` / `<Enter>` で、ディレクトリなら移動・ファイルなら開くプラグイン
- `scripts/update-upstream.sh` — 上流の既定の設定を取得して `main` に積む（作業ツリーと index には触れない）

## 確かめ方

テストは無い。検証記録で使った確かめ方:

```sh
python3 -c 'import sys, tomllib; [tomllib.load(open(f, "rb")) for f in sys.argv[1:]]' yazi.toml keymap.toml theme.toml vfs.toml
bash -n scripts/update-upstream.sh
```

- TOML の構文は、Python 3.11 以上の `tomllib` で確かめる
- キーの動きは、設定を一時ディレクトリにコピーし、`YAZI_CONFIG_HOME` にそこを入れて yazi を起動して確かめる。起動時に `Failed to parse config` が出ないこと

## 書き方の規則

- Windows・AlmaLinux の操作は setup-notes の2冊、構成と理由は `docs/reference/readme.md`、実施日・環境・結果は `docs/verification/readme.md` に分ける
- 検証していないことを「動く」と書かない。検証記録の過去の節は書き換えず、新しい節を足す

## 共同作業の規則

このリポジトリでは、Claude Code・Codex・Grok Build・Antigravity CLI が同じ規則で作業する。分担と `custom` への取り込みは人が決める。

- 起動された worktree（作業ディレクトリ）の中だけでファイルを変える。ほかの worktree のファイルは変えない
- 今のブランチにだけコミットする。`custom` にはコミットも push もしない
- 頼まれた範囲のファイルだけを変える。範囲の外を変えるときは、変える前に理由を書いて確かめる
- 終わったら、テストとリンターを通してから、目的ごとにコミットする。通らなければコミットせずに、結果を報告する
- コミットしたら、今のブランチを push し、`custom` への Pull Request を作る（既にあれば足す）。`custom` への取り込み（マージ）とブランチの削除は人が行う。今のブランチに `custom` を取り込むのは、頼まれたときと、Pull Request が競合したときだけ
- 秘密情報（`.env`・鍵・トークン・パスワード）を読まない・書かない・出力しない
- レビューを頼まれたら、ファイルを変えずに、指摘を「重大度・場所（ファイル:行）・理由・直し方」で挙げる
- ほかの担当の変更は、`git diff custom...agent/codex` のように git で読む（ほかの worktree へ移らない）
- `main` は上流の追従用。上流の追従を頼まれたとき以外は変えない

## 既定の分担

利用者が Claude Code に、分担を指定せずにファイルを変える作業を頼んだときは、Claude Code が取りまとめて次の 4 つで分担する（2026-10-15、利用者の決定）。「共同作業の規則」の「分担は人が決める」で、人が分担を決めていないときの既定にする。利用者がほかのエージェントに直接頼んだときは、この節は使わず「共同作業の規則」に従う。

- Claude Code だけで行うもの: 利用者の質問への答え、ファイルを変えない調べもの、1 つのファイルの数行で振る舞いを変えない直し（誤字・リンク・値の直しなど）
- Claude Code: 計画・実機での確かめ・ほかの 3 つへの依頼・指摘の確かめ・統合・コミットと Pull Request
- Codex: 実装と下書き。Claude Code が用意した別の clone か worktree の中だけで書く。この分担で頼まれたときは、「共同作業の規則」のコミット・push・Pull Request を行わず、変更を残して報告する（Claude Code が確かめ、自分の worktree に移してからコミットする）
- Grok Build: 差分の読み取り専用のレビュー。ファイルを変えない（Windows 11 では、Claude Code は `--always-approve` を付けずに頼む）
- Antigravity CLI（Windows 11 だけ）: 差分の読み取り専用のレビューと、その作業のための調べもの。ファイルを変えない（Claude Code は、入力を写した使い捨てのフォルダーで 1 回だけ実行し、`--dangerously-skip-permissions`・`--mode` を付けない）
- Claude Code から頼まれたエージェントは、上の自分の役割の範囲で作業する
- レビューの指摘は、実物で確かめてから採る。採らなかった指摘は、理由を付けて報告する
- 使えないエージェント（入っていない・ログインが切れた・AlmaLinux 10 の Antigravity CLI）は飛ばし、そのことを報告する
- 頼み方は、setup-notes（https://github.com/ryo-aoki-pc/setup-notes）の `docs/ai-agents.md` の「コーディングエージェントの共同作業: 既定で分担する」と、`docs/reference/coding-agents.md` の「既定の分担」
