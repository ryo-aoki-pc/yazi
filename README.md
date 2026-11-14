# yazi

[yazi](https://github.com/sxyazi/yazi)(ターミナルファイルマネージャ)の個人設定です。

## 導入

- 対象: AlmaLinux 10・Windows 11・Android の Termux の自分のユーザー。AlmaLinux 10 の手順は setup-notes にある。Windows 11 は、本体・依存コマンドと自分用の設定(`custom` ブランチ)が入っていることを前提にする
- 置き場所は `~/.config/yazi`(Windows は `%APPDATA%\yazi\config`)

| | AlmaLinux 10 | Windows 11 |
| --- | --- | --- |
| 前提(導入元と端末) | [共通の bash 設定](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/shell-terminal.md#共通の-bash-設定)・[Homebrew](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/almalinux-setup.md#homebrew)・[WezTerm](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/shell-terminal.md#wezterm) | [scoop](https://scoop.sh/)・[WezTerm](https://wezterm.org/install/windows.html) の Git Bash と共通の bash 設定が使えること（Visual C++ ランタイムの x64 版は[公式の案内](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist)に従って入れてあること） |
| 本体・依存コマンドとこの設定 | [yazi](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/almalinux-setup.md#yazi)(手順 3 で「yazi の設定を導入する」も通す) | [yazi の公式の導入案内](https://yazi-rs.github.io/docs/installation/)。自分用の設定が入っていること |
| この設定だけ(本体が入っているとき) | [yazi の設定を導入する](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/almalinux-setup.md#yazi-の設定を導入する) | `%APPDATA%\yazi\config` にこの設定の `custom` ブランチの clone があること |
| 複数ファイルをまとめて開く(任意) | [yazi で複数ファイルをまとめて開く](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/almalinux-setup.md#yazi-で複数ファイルをまとめて開く) | [yazi で複数ファイルをまとめて開く](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/windows-setup.md#yazi-で複数ファイルをまとめて開く) |
| この設定の更新 | [yazi の設定を更新する](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/almalinux-setup.md#yazi-の設定を更新する) | [yazi の設定を更新する](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/windows-setup.md#yazi-の設定を更新する) |
| 本体の更新 | [共通の bash 設定・Homebrew・Flatpak を上げる](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/almalinux-setup.md#共通の-bash-設定homebrewflatpak-を上げる)の手順 2・3 | [scoop・winget・WSL を上げる](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/windows-setup.md#scoopwingetwsl-を上げる)の手順 2・3 |

yazi の版が上がったら、リポジトリの所有者が[上流の新しい版に追従する](#上流の新しい版に追従する)で、この設定を新しい既定設定の上に載せ替えます(`custom` を force push する)。ほかのマシンの clone は、[導入](#導入)の表の「この設定の更新」で合わせます。

macOS(手順と検証は無い)は、次で設定を置きます。

```sh
git clone -b custom https://github.com/ryo-aoki-pc/yazi.git ~/.config/yazi
```

## 依存コマンド

設定の一部は外部コマンドに依存します。利用するキーと合わせて導入してください。

| コマンド | 用途 | 関連キー |
| --- | --- | --- |
| [`nvim`](https://neovim.io/) | ファイル編集(エディタ) | `o` / `<Enter>` |
| [`fd`](https://github.com/sharkdp/fd) | ファイル名検索 | `s` |
| [`ripgrep`](https://github.com/BurntSushi/ripgrep)(`rg`) | ファイル内容検索 | `S` |
| [`fzf`](https://github.com/junegunn/fzf) | ファイル/ディレクトリ絞り込み | `z` |
| [`zoxide`](https://github.com/ajeetdsouza/zoxide) | ディレクトリへジャンプ | `Z` |

yazi はファイルの種類の判定に `file` を使います。Windows では Git for Windows の `file.exe` を使うように設定します([yazi の公式の Windows の案内](https://yazi-rs.github.io/docs/installation/#windows)の `YAZI_FILE_ONE`)。また Windows では、`O`(対話的に開く)の候補に [`neovide`](https://neovide.dev/) も出ます(`yazi.toml` の `edit` の opener)。候補はコマンドの有無で絞られないので、選んで使うときは neovide を入れておきます。

## 上流との差分を確認する

自分の変更だけを見る:

```sh
git diff main custom -- '*.toml'
```

上流の版どうしの差分を見る:

```sh
git diff upstream/v26.5.6 upstream/v26.9.1
```

## 上流の新しい版に追従する

yazi の版が上がったら、この手順で設定も新しい既定設定の上に載せ替えます(setup-notes の更新の項から案内しています)。`main` は上流の既定設定を保つブランチです。手で編集せず、作業ツリーで checkout もしないでください。

```sh
bash scripts/update-upstream.sh           # インストール済み yazi の版を取得して main に積む(タグ引数で版を指定できる)
git rebase main custom                    # 自分の変更を新しい既定設定の上に載せ替える。衝突があれば解決する
git push origin main && git push --force-with-lease origin custom && git push origin --tags
```

スクリプトは checkout や worktree を使わず、`main` にコミットを作るだけなので、作業ツリーには触れません。上流に同じ版が既にあれば何もしません。

## 文書

- [構成・上流との差分管理・独自キーバインド](docs/reference/readme.md)
- 検証記録（`repos/yazi/docs/verification/readme.md`）
- 確かめ方と、変更するときの決まりは [AGENTS.md](AGENTS.md)
