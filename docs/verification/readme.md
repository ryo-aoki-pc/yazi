# yazi 検証記録

[導入・更新手順](../../README.md)

## 新規 AlmaLinux VM での検証 (2026-10-06)

- AlmaLinux 10.2 Workstation / x86_64 の新規 VM に yazi 26.9.1 と依存コマンドを入れ、公開 URL から `custom` / `41c5124` を `~/.config/yazi` に clone した。共通 bash `3d5323e` の `y` 関数を使った
- SSH 対話 PTY の実 TUI で 3 ペイン、隠しファイル、サイズと更新日時、テキストのプレビューを確認した。`l` でディレクトリに入り、Enter でファイルが Neovim に開き、`:qa` で戻った。`q` の後にシェルが空白・日本語を含むパスへ移り、`gT` → `q` では `/tmp` へ移った。動かず終了したときも cwd は同じだった
- 4 個の TOML は構文解析を通り、更新スクリプトは `bash -n` を通った。上流の取得・main へのコミット・rebase・push は今回は実行していない。Windows / macOS、GUI の画像等のプレビュー、検索、複数ファイル用の任意設定も今回の範囲には含めない

## Windows 向けの変更の Linux での検証 (2026-10-08)

- Ubuntu 24.04.5 LTS / x86_64 のコンテナで、GitHub の release の `yazi-x86_64-unknown-linux-gnu.zip`(v26.9.1。`yazi --version` と `ya --version` は `26.9.1 (8dd895c 2026-09-01)`)を展開して使った。作業ツリーの設定を一時ディレクトリにコピーし、そこを `YAZI_CONFIG_HOME` にして tmux 3.4 の 150x30 の窓で `yazi --cwd-file=…` を起動した。`ya env` の Config の各行もそのコピーを指した
- 4 個の TOML は Python 3.13.16 の `tomllib` で構文解析を通った。Windows 用の 2 行は `run` が `cd C:\`(末尾の `\` は 1 個)と `cd %TEMP%`、`desc` が `Go to C:\` と `Go to %TEMP%` として読まれた
- `/home/user` で起動し、`g` `/` で上端の cwd 表示が `/` に、続く `g` `T` で `/tmp` になった。`q` の終了コードは 0、cwd-file は `/tmp` だった。逆の順(`gT` → `g/`)では cwd-file は `/` だった。画面(capture-pane)にも標準エラーにも設定のエラーは出なかった
- Windows 用の行を Unix 用の行より前に並べ替えたコピーでも `g/` は `/`、`gT` は `/tmp` に移り、Linux では `for = "windows"` の行が使われないことを確かめた。`for` を `"windowz"` にしたコピーでは起動時に `Failed to parse config` と `` unknown variant `windowz` `` が出た(設定のエラーがあれば画面に出ることの確認)
- 分割器の確認として、`run = 'cd <一時ディレクトリ>/split/C:\'` の行を足したコピーで、`C:` と `C:\` の 2 つのディレクトリがある場所から `C:\` の方へ移った。`run = 'cd <一時ディレクトリ>/split/C:\dev'` の行を足したコピーでは、`C:dev` と `C:\dev` の 2 つのディレクトリがある場所から `C:dev` の方へ移った(終了コード 0、標準エラーは空)。`run` の分割器は OS によらず同じなので、末尾の `\` が残ることと途中の `\` が消えることは Windows でも同じと見ている
- `yazi.toml` の neovide の行を `for = "linux"` にしたコピーで、neovide も nvim も無い環境でテキストのファイルに `O` を押すと、Open with: に nvim・neovide・Reveal・Show EXIF が出た(opener はコマンドの有無で絞られない)。変えていない設定では nvim・Reveal・Show EXIF だった
- README の Windows の 2 つの PowerShell のブロックは、PowerShell 7.6.0(GitHub の release の linux-x64)のパーサーで構文エラーが 0 件だった。clone のブロックは、Linux 用にパスの区切りを `/`、clone 元をローカルの作業リポジトリに替えたコピーを、`APPDATA` を変えて `pwsh -File` で 4 通り流した。設定が無いときは clone して `custom` を表示し(親のディレクトリも作られた)、`config` だけあるときは `config.bak` に移してから clone して `custom` を表示し、`config` と `config.bak` が両方あるときは `Write-Error` で止まってどちらも変わらなかった。`chattr +i` で `yazi` のディレクトリの中の名前の変更を止めたときは `Move-Item` のエラーで止まり、clone も `branch --show-current` も実行されなかった(`-ErrorAction Stop` を外したコピーでは、続けて git clone が `destination path … already exists` で失敗した)
- GitHub の release の `yazi-x86_64-pc-windows-msvc.zip`(v26.9.1)に入っている実行ファイルは `yazi.exe` と `ya.exe` で、DLL は入っていなかった。GNU objdump 2.42 で読んだ 2 つの取り込む DLL には、どちらも `VCRUNTIME140.dll` があった
- Windows では何も実行していない。Windows PowerShell 5.1 での README のブロックの実行、`%APPDATA%\yazi\config` への clone、`YAZI_FILE_ONE` の設定と効き方、`vcruntime140.dll` が無いときの yazi の動き、`g/`(`C:\`)・`gT`(`%TEMP%` の展開。Git Bash から起動したときの値も含む。Git for Windows の `/etc/profile` は `TEMP=/tmp` にする)・`gh` / `gc` / `gd`(`~` の置き換え)の実際の行き先は未検証
