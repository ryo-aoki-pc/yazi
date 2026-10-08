# yazi 設定の導入

[文書一覧](README.md) / [設定内容・キー操作](reference/readme.md) / [検証記録](verification/readme.md)

yazi 本体の導入・更新・削除は [setup-notes の導入手順](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/yazi.md)を参照してください。この文書では、このリポジトリの個人設定を配置します。

## 依存コマンド

設定の一部は外部コマンドに依存します。利用するキーと合わせて導入してください。

| コマンド | 用途 | 関連キー |
| --- | --- | --- |
| [`nvim`](https://neovim.io/) | ファイル編集(エディタ) | `o` / `<Enter>` |
| [`fd`](https://github.com/sharkdp/fd) | ファイル名検索 | `s` |
| [`ripgrep`](https://github.com/BurntSushi/ripgrep)(`rg`) | ファイル内容検索 | `S` |
| [`fzf`](https://github.com/junegunn/fzf) | ファイル/ディレクトリ絞り込み | `z` |
| [`zoxide`](https://github.com/ajeetdsouza/zoxide) | ディレクトリへジャンプ | `Z` |

yazi はファイルの種類の判定に `file` を使います。Windows では Git for Windows の `file.exe` を使うように設定します([インストール](#インストール)の `YAZI_FILE_ONE`)。また Windows では、`O`(対話的に開く)の候補に [`neovide`](https://neovide.dev/) も出ます(`yazi.toml` の `edit` の opener)。候補はコマンドの有無で絞られないので、選んで使うときは neovide を入れておきます。

## インストール

このリポジトリの `custom` ブランチを、Linux / macOS では `~/.config/yazi` に配置します。

```sh
git clone -b custom https://github.com/ryo-aoki-pc/yazi.git ~/.config/yazi
```

Windows では `%APPDATA%\yazi\config` に配置します。Windows の yazi は `XDG_CONFIG_HOME` を読みません(別の場所に置くときは `YAZI_CONFIG_HOME` に絶対パスを入れます)。yazi を終了してから、次を Windows PowerShell に貼ります。既存の設定があれば `config.bak` に退避し、`config.bak` も既にあるときは何もせずに止まります。

```powershell
$dst = "$env:APPDATA\yazi\config"
if ((Test-Path -LiteralPath $dst) -and (Test-Path -LiteralPath "$dst.bak")) {
  Write-Error "中断: $dst.bak が既にある。中身を確かめて片付けてから貼り直す"
} else {
  if (Test-Path -LiteralPath $dst) { Move-Item -LiteralPath $dst -Destination "$dst.bak" -ErrorAction Stop }
  git clone -b custom https://github.com/ryo-aoki-pc/yazi.git $dst
  git -C $dst branch --show-current
}
```

`custom` が表示されれば clone は完了です。yazi が読む場所は `ya env` の Config の各行で確かめられます。

Windows ではさらに、ユーザー環境変数 `YAZI_FILE_ONE` に Git for Windows の `usr\bin\file.exe` を入れます([yazi の文書](https://yazi-rs.github.io/docs/installation#windows))。Git for Windows をインストーラの既定の場所に入れた場合は次のとおりです。設定した後に開いた端末から効きます。

```powershell
[Environment]::SetEnvironmentVariable('YAZI_FILE_ONE', 'C:\Program Files\Git\usr\bin\file.exe', 'User')
```

Windows の `yazi.exe`・`ya.exe` は Visual C++ ランタイム(`VCRUNTIME140.dll`)を必要とします。PowerShell で `Test-Path "$env:WINDIR\System32\vcruntime140.dll"` が `False` の場合は、先に [Visual C++ 再頒布可能パッケージ](https://learn.microsoft.com/ja-jp/cpp/windows/latest-supported-vc-redist)の X64 版を入れます。

Windows の実機ではまだ試していません。確認した範囲は[検証記録](verification/readme.md)にあります。

## 補足: 複数ファイルをまとめて開く

`l` / `<Enter>` は既定ではホバー中の1ファイルのみを開きます。選択した複数ファイルをまとめて開きたい場合は、`init.lua` に次を追記してください。

```lua
require("smart-enter"):setup { open_multi = true }
```
