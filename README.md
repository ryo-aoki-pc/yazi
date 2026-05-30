# yazi-config

[yazi](https://github.com/sxyazi/yazi)（ターミナルファイルマネージャ）の個人設定です。

## 構成

| ファイル | 内容 |
| --- | --- |
| `yazi.toml` | 基本設定。3ペイン構成（比率 `1:4:3`）、隠しファイル表示、行表示モード `size_and_mtime`、エディタは nvim。 |
| `keymap.toml` | キーバインド。Vim 風操作 + 後述の独自バインド。 |
| `theme.toml` | 配色・アイコン定義。 |
| `init.lua` | カスタム行表示モード `size_and_mtime`（サイズ + 更新日時）を定義。 |
| `plugins/smart-enter.yazi/` | `l` / `<Enter>` で「ディレクトリなら移動・ファイルなら開く」プラグイン（同梱）。 |

## 依存コマンド

設定の一部は外部コマンドに依存します。利用するキーと合わせて導入してください。

| コマンド | 用途 | 関連キー |
| --- | --- | --- |
| [`nvim`](https://neovim.io/) | ファイル編集（エディタ） | `o` / `<Enter>` |
| [`fd`](https://github.com/sharkdp/fd) | ファイル名検索 | `s` |
| [`ripgrep`](https://github.com/BurntSushi/ripgrep)（`rg`） | ファイル内容検索 | `S` |
| [`fzf`](https://github.com/junegunn/fzf) | ファイル/ディレクトリ絞り込み | `z` |
| [`zoxide`](https://github.com/ajeetdsouza/zoxide) | ディレクトリへジャンプ | `Z` |

## 独自キーバインド（抜粋）

| キー | 動作 |
| --- | --- |
| `l` / `<Enter>` | スマートエンター（ディレクトリは移動、ファイルは開く） |
| `o` | 開く（ファイルを既定アプリで開く） |
| `g/` | ルート `/` へ移動 |
| `gt` | `/tmp` へ移動 |
| `gh` / `gc` / `gd` | ホーム / `~/.config` / `~/Downloads` へ移動 |
| `,` + キー | ソート切替（`,m` 更新日時、`,s` サイズ、`,n` 自然順 など） |
| `m` + キー | 行表示モード切替（`ms` サイズ、`mp` パーミッション など） |
| `c` + キー | パス系コピー（`cc` フルパス、`cd` ディレクトリ、`cf` ファイル名、`cn` 拡張子なし） |
| `s` / `S` | fd で名前検索 / ripgrep で内容検索 |
| `z` / `Z` | fzf で絞り込み / zoxide でジャンプ |

そのほかの操作は yazi 内で `~` または `<F1>` を押すとヘルプで一覧できます。

## インストール

このリポジトリを `~/.config/yazi` に配置します。

```sh
git clone <このリポジトリのURL> ~/.config/yazi
```

## 補足: 複数ファイルをまとめて開く

`l` / `<Enter>` は既定ではホバー中の1ファイルのみを開きます。選択した複数ファイルをまとめて開きたい場合は、`init.lua` に次を追記してください。

```lua
require("smart-enter"):setup { open_multi = true }
```
