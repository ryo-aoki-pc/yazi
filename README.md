# yazi

[yazi](https://github.com/sxyazi/yazi)(ターミナルファイルマネージャ)の個人設定です。

## 導入

- 対象: AlmaLinux 10 と Windows 11 の自分のユーザー。手順は setup-notes にあり、本体と依存コマンドを入れてから、この設定(`custom` ブランチ)を clone する
- 置き場所は `~/.config/yazi`(Windows は `%APPDATA%\yazi\config`)

| | AlmaLinux 10 | Windows 11 |
| --- | --- | --- |
| 本体・依存コマンドとこの設定 | [yazi](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/almalinux-setup.md#yazi)(手順 3 で「yazi の設定を導入する」も通す) | [yazi](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/windows-setup.md#yazi)(`YAZI_FILE_ONE` もここで設定する。手順 6 で「yazi の設定を導入する」も通す) |
| この設定だけ(本体が入っているとき) | [yazi の設定を導入する](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/almalinux-setup.md#yazi-の設定を導入する) | [yazi の設定を導入する](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/windows-setup.md#yazi-の設定を導入する) |
| 複数ファイルをまとめて開く(任意) | [yazi で複数ファイルをまとめて開く](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/almalinux-setup.md#yazi-で複数ファイルをまとめて開く) | [yazi で複数ファイルをまとめて開く](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/windows-setup.md#yazi-で複数ファイルをまとめて開く) |
| この設定の更新 | [yazi の設定を更新する](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/almalinux-setup.md#yazi-の設定を更新する) | [yazi の設定を更新する](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/windows-setup.md#yazi-の設定を更新する) |
| 本体の更新 | [共通の bash 設定・Homebrew・Flatpak を上げる](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/almalinux-setup.md#共通の-bash-設定homebrewflatpak-を上げる)の手順 2・3 | [scoop・winget・WSL を上げる](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/windows-setup.md#scoopwingetwsl-を上げる)の手順 2・3 |
| 戻す | [端末とエディタを消す](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/extra/almalinux-setup.md#端末とエディタを消す)の手順 1 (この設定の clone の消し方は、その箇条書き) | [エディタとシェルのツールを消す](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/extra/windows-setup.md#エディタとシェルのツールを消す)の手順 1〜3 |

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

yazi はファイルの種類の判定に `file` を使います。Windows では Git for Windows の `file.exe` を使うように設定します(setup-notes の Windows 11 の[yazi](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/windows-setup.md#yazi)で設定する `YAZI_FILE_ONE`)。また Windows では、`O`(対話的に開く)の候補に [`neovide`](https://neovide.dev/) も出ます(`yazi.toml` の `edit` の opener)。候補はコマンドの有無で絞られないので、選んで使うときは neovide を入れておきます。

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
- [検証記録](docs/verification/readme.md)
- 確かめ方と、変更するときの決まりは [AGENTS.md](AGENTS.md)
- 旧手順書の移動先: setup-notes の[集約対応表](https://github.com/ryo-aoki-pc/setup-notes/blob/main/docs/dev/consolidation-map.md)
