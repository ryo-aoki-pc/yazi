# AGENTS.md

このリポジトリで作業するコーディングエージェント（Claude Code・Codex・Grok Build・Antigravity CLI）への指示。Claude Code は CLAUDE.md の `@AGENTS.md` で、Codex・Grok Build・Antigravity CLI はこのファイルを直接読む。

## 導入手順の正本

導入・更新・使い方の手順は、setup-notes の [almalinux-setup.md](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/almalinux-setup.md#yazi) と [windows-setup.md](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/windows-setup.md#yazi) の「yazi」とその子の項にある。このリポジトリには置かない。上流の新しい版への追従(設定の更新)と、macOS の導入は README に置く。

## このリポジトリは何か

[yazi](https://github.com/sxyazi/yazi)（端末のファイルマネージャー）の自分用の設定。Linux / macOS と Android の Termux は `~/.config/yazi`、Windows は `%APPDATA%\yazi\config` に `custom` を clone して使う。導入の表と上流への追従は [README.md](README.md)、構成・ブランチ・独自のキーは [docs/reference/readme.md](docs/reference/readme.md)、検証記録は `repos/yazi/docs/verification/readme.md`。

ドキュメント・コミットメッセージ・Pull Request の説明は日本語で書く。

### ブランチ構成と構成

- `custom` が実際に使う設定(既定のブランチ。作業はここから始める)、`main` が上流の既定の設定そのもの(手で編集しない。作業ツリーで checkout もしない)
- 4 つの `*.toml` は、上流の既定の設定を丸ごと置いたうえで、変えたい箇所だけを編集する。自分の変更は `git diff main custom -- '*.toml'` で見る
- ファイルの役割と、上流のファイル名との対応は `docs/reference/readme.md` の「構成」「上流との差分管理」。上流への追従は README の「上流の新しい版に追従する」

Pull Request の向き先は `custom`。`main` は上流の追従用で、上流の追従を頼まれたとき以外は変えない。

## 確かめ方

テストは無い。検証記録で使った確かめ方:

```sh
python3 -c 'import sys, tomllib; [tomllib.load(open(f, "rb")) for f in sys.argv[1:]]' yazi.toml keymap.toml theme.toml vfs.toml
bash -n scripts/update-upstream.sh
```

- TOML の構文は、Python 3.11 以上の `tomllib` で確かめる
- キーの動きは、設定を一時ディレクトリにコピーし、`YAZI_CONFIG_HOME` にそこを入れて yazi を起動して確かめる。起動時に `Failed to parse config` が出ないこと

## 文書の置き場所

- 導入・利用・更新の手順は正本に置き、README の「導入」の表から正本の項へ直接リンクする(手順書の先頭やカテゴリの見出しへはリンクしない)。執筆規則は setup-notes の `docs/dev/writing-rules.md`
- `docs/reference/` は構成と理由。検証記録(実施日・環境・結果・未確認事項)は Forgejo の非公開リポジトリ `setup-notes-verification` の `repos/yazi/docs/verification/` に置く。ロールバック（取り消し）の手順は書かない
- setup-notes から張られている README の見出し(「依存コマンド」「上流の新しい版に追従する」)は、名前を変えない
- 文書を移す・分ける・まとめるときは、移した経緯と、旧ファイル名・旧見出しとの対応を文書に書かない(経緯は git の履歴と Pull Request の本文に残す)。リンクを今の場所へ直す。中身が新しい場所への案内だけになったファイルは消す
- 検証記録を書く・直すときは、Forgejo の非公開リポジトリ `setup-notes-verification` を clone し、そちらへ Pull Request を作る。このリポジトリから検証記録へは URL で指さず、「`<検証記録のパス>` の「<見出し>」」と文字で書く（見出しを指さないときは、同じ名前の文書の記録なら「検証記録」とだけ書き、ほかの記録はパスを添える）
- 検証していないことを「動く」と書かない。残す検証記録の実施日・対象版・環境・出力・成功と失敗・未実施の範囲・記録したときの手順番号は書き換えない。再検証せずに検証範囲を広げない。記録の手順番号が今の手順と違い、本文を読むのに要るときだけ「記録の手順 | 今の手順」の表で結ぶ。新しい検証は新しい節に足す
