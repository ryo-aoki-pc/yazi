# yazi 検証記録

[導入・更新手順](../../README.md)

## 新規 AlmaLinux VM での検証 (2026-10-06)

- AlmaLinux 10.2 Workstation / x86_64 の新規 VM に yazi 26.9.1 と依存コマンドを入れ、公開 URL から `custom` / `41c5124` を `~/.config/yazi` に clone した。共通 bash `3d5323e` の `y` 関数を使った
- SSH 対話 PTY の実 TUI で 3 ペイン、隠しファイル、サイズと更新日時、テキストのプレビューを確認した。`l` でディレクトリに入り、Enter でファイルが Neovim に開き、`:qa` で戻った。`q` の後にシェルが空白・日本語を含むパスへ移り、`gT` → `q` では `/tmp` へ移った。動かず終了したときも cwd は同じだった
- 4 個の TOML は構文解析を通り、更新スクリプトは `bash -n` を通った。上流の取得・main へのコミット・rebase・push は今回は実行していない。Windows / macOS、GUI の画像等のプレビュー、検索、複数ファイル用の任意設定も今回の範囲には含めない
