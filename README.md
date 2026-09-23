# yazi-config

[yazi](https://github.com/sxyazi/yazi)(ターミナルファイルマネージャ)の個人設定です。

## 構成

| ファイル | 内容 |
| --- | --- |
| `yazi.toml` | 基本設定。3ペイン構成(比率 `1:4:3`)、隠しファイル表示、行表示モード `size_and_mtime`、エディタは nvim。 |
| `keymap.toml` | キーバインド。Vim 風操作 + 後述の独自バインド。 |
| `theme.toml` | 配色・アイコン定義。上流の `theme-dark.toml` と同じ内容で、独自変更はない。 |
| `vfs.toml` | 仮想ファイルシステム定義(ゴミ箱など)。上流既定のまま。 |
| `init.lua` | カスタム行表示モード `size_and_mtime`(サイズ + 更新日時)を定義。 |
| `plugins/smart-enter.yazi/` | `l` / `<Enter>` で「ディレクトリなら移動・ファイルなら開く」プラグイン(同梱)。 |
| `scripts/update-upstream.sh` | 上流の既定設定を取得して `main` ブランチに積むスクリプト([上流との差分管理](#上流との差分管理))。 |

## 上流との差分管理

4 つの `*.toml` は、上流リポジトリの既定設定 [`yazi-config/preset/`](https://github.com/sxyazi/yazi/tree/main/yazi-config/preset) を丸ごと置いたうえで、変更したい箇所だけ編集しています。どこを変えたかが分かるように、ブランチを 2 本に分けています。

| ブランチ | 内容 |
| --- | --- |
| `main` | 上流の既定設定そのもの。ファイル名だけこのリポジトリ用に変えてある(下表)。**手で編集しない。作業ツリーで checkout もしない。** |
| `custom` | 実際に使う設定(GitHub の既定ブランチ)。`main` の上に自分の変更を rebase で載せている。 |

| `main` のファイル | 上流の `yazi-config/preset/` |
| --- | --- |
| `yazi.toml` | `yazi-default.toml` |
| `keymap.toml` | `keymap-default.toml` |
| `theme.toml` | `theme-dark.toml` |
| `vfs.toml` | `vfs-default.toml` |

`main` の各コミットには上流の版のタグ `upstream/vX.Y.Z` を付けています。現在追跡している版は **v26.9.1** です。

自分の変更だけを見る:

```sh
git diff main custom -- '*.toml'
```

上流の版どうしの差分を見る:

```sh
git diff upstream/v26.5.6 upstream/v26.9.1
```

### 上流の新しい版に追従する

```sh
bash scripts/update-upstream.sh           # インストール済み yazi の版を取得して main に積む(タグ引数で版を指定できる)
git rebase main custom                    # 自分の変更を新しい既定設定の上に載せ替える。衝突があれば解決する
git push origin main && git push --force-with-lease origin custom && git push origin --tags
```

スクリプトは checkout や worktree を使わず、`main` にコミットを作るだけなので、作業ツリーには触れません。上流に同じ版が既にあれば何もしません。

## 依存コマンド

設定の一部は外部コマンドに依存します。利用するキーと合わせて導入してください。

| コマンド | 用途 | 関連キー |
| --- | --- | --- |
| [`nvim`](https://neovim.io/) | ファイル編集(エディタ) | `o` / `<Enter>` |
| [`fd`](https://github.com/sharkdp/fd) | ファイル名検索 | `s` |
| [`ripgrep`](https://github.com/BurntSushi/ripgrep)(`rg`) | ファイル内容検索 | `S` |
| [`fzf`](https://github.com/junegunn/fzf) | ファイル/ディレクトリ絞り込み | `z` |
| [`zoxide`](https://github.com/ajeetdsouza/zoxide) | ディレクトリへジャンプ | `Z` |

## 独自キーバインド(抜粋)

| キー | 動作 |
| --- | --- |
| `l` / `<Enter>` | スマートエンター(ディレクトリは移動、ファイルは開く) |
| `o` | 開く(ファイルを既定アプリで開く) |
| `g/` | ルート `/` へ移動 |
| `gT` | `/tmp` へ移動(`gt` は上流既定のゴミ箱表示に譲っている) |
| `gh` / `gc` / `gd` | ホーム / `~/.config` / `~/Downloads` へ移動 |
| `,` + キー | ソート切替(`,m` 更新日時、`,s` サイズ、`,n` 自然順 など) |
| `m` + キー | 行表示モード切替(`ms` サイズ、`mp` パーミッション など) |
| `c` + キー | パス系コピー(`cc` フルパス、`cd` ディレクトリ、`cf` ファイル名、`cn` 拡張子なし) |
| `s` / `S` | fd で名前検索 / ripgrep で内容検索 |
| `z` / `Z` | fzf で絞り込み / zoxide でジャンプ |

そのほかの操作は yazi 内で `~` または `<F1>` を押すとヘルプで一覧できます。

## インストール

このリポジトリの `custom` ブランチを `~/.config/yazi` に配置します。

```sh
git clone -b custom <このリポジトリのURL> ~/.config/yazi
```

## 補足: 複数ファイルをまとめて開く

`l` / `<Enter>` は既定ではホバー中の1ファイルのみを開きます。選択した複数ファイルをまとめて開きたい場合は、`init.lua` に次を追記してください。

```lua
require("smart-enter"):setup { open_multi = true }
```
