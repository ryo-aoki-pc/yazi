# yazi

[yazi](https://github.com/sxyazi/yazi)(ターミナルファイルマネージャ)の個人設定です。

[設定構成・キーバインド・ブランチ構成](docs/reference/readme.md) / [検証記録](docs/verification/readme.md)

## 依存コマンド

設定の一部は外部コマンドに依存します。利用するキーと合わせて導入してください。

| コマンド | 用途 | 関連キー |
| --- | --- | --- |
| [`nvim`](https://neovim.io/) | ファイル編集(エディタ) | `o` / `<Enter>` |
| [`fd`](https://github.com/sharkdp/fd) | ファイル名検索 | `s` |
| [`ripgrep`](https://github.com/BurntSushi/ripgrep)(`rg`) | ファイル内容検索 | `S` |
| [`fzf`](https://github.com/junegunn/fzf) | ファイル/ディレクトリ絞り込み | `z` |
| [`zoxide`](https://github.com/ajeetdsouza/zoxide) | ディレクトリへジャンプ | `Z` |

## インストール

このリポジトリの `custom` ブランチを `~/.config/yazi` に配置します。

```sh
git clone -b custom https://github.com/ryo-aoki-pc/yazi.git ~/.config/yazi
```

## 補足: 複数ファイルをまとめて開く

`l` / `<Enter>` は既定ではホバー中の1ファイルのみを開きます。選択した複数ファイルをまとめて開きたい場合は、`init.lua` に次を追記してください。

```lua
require("smart-enter"):setup { open_multi = true }
```

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

`main` は上流の既定設定を保つブランチです。手で編集せず、作業ツリーで checkout もしないでください。

```sh
bash scripts/update-upstream.sh           # インストール済み yazi の版を取得して main に積む(タグ引数で版を指定できる)
git rebase main custom                    # 自分の変更を新しい既定設定の上に載せ替える。衝突があれば解決する
git push origin main && git push --force-with-lease origin custom && git push origin --tags
```

スクリプトは checkout や worktree を使わず、`main` にコミットを作るだけなので、作業ツリーには触れません。上流に同じ版が既にあれば何もしません。
