# yazi 設定リファレンス

[導入・更新手順](../../README.md) / [検証記録](../verification/readme.md)

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

## 独自キーバインド(抜粋)

| キー | 動作 |
| --- | --- |
| `l` / `<Enter>` | スマートエンター(ディレクトリは移動、ファイルは開く) |
| `o` | 開く(ファイルを既定アプリで開く) |
| `g/` | ルートへ移動(Linux / macOS は `/`、Windows は `C:\`) |
| `gT` | 一時ディレクトリへ移動(Linux / macOS は `/tmp`、Windows は `%TEMP%`。`gt` は上流既定のゴミ箱表示に譲っている) |
| `gh` / `gc` / `gd` | ホーム / `~/.config` / `~/Downloads` へ移動 |
| `,` + キー | ソート切替(`,m` 更新日時、`,s` サイズ、`,n` 自然順 など) |
| `m` + キー | 行表示モード切替(`ms` サイズ、`mp` パーミッション など) |
| `c` + キー | パス系コピー(`cc` フルパス、`cd` ディレクトリ、`cf` ファイル名、`cn` 拡張子なし) |
| `s` / `S` | fd で名前検索 / ripgrep で内容検索 |
| `z` / `Z` | fzf で絞り込み / zoxide でジャンプ |

そのほかの操作は yazi 内で `~` または `<F1>` を押すとヘルプで一覧できます。

### OS で行き先を分けているキー

`g/` と `gT` の行き先 `/`・`/tmp` は Unix のパスなので、`keymap.toml` ではこの 2 行に `for = "unix"` を付け、すぐ後に `for = "windows"` の行を置いています([keymap の Per-OS](https://yazi-rs.github.io/docs/configuration/keymap#per-os))。`for` が合わない行は読み込み時に除かれるので、同じキーの行が OS ごとに 1 つだけ効きます。Windows で `/tmp` は無く、`cd /` の行き先も確かめていないため分けました。

- `g/` (Windows): `run = 'cd C:\'`。yazi は keymap の `run` の文字列をどの OS でも sh 風の分割器で区切り、引用符の外の `\` は次の 1 文字を残して消えます(`cd C:\dev` は `C:dev` になる。リンク先の上流の例 `'cd C:\dev'` もこれにあたる)。末尾の `\` だけはそのまま残るので、ドライブのルートはこの形で書けます。TOML のリテラル文字列(`'…'`)にして `\` を TOML のエスケープにしないようにしています。下の階層を足すときは `/` で区切るか、リテラル文字列の中で `\\` と重ねます(`'cd C:\\dev'`)
- `gT` (Windows): `run = "cd %TEMP%"`。yazi は Windows では `cd` の行き先の `%VAR%` を環境変数で展開します(Unix では `$VAR` / `${VAR}`)
- `gh` / `gc` / `gd` は上流の既定の行のままで、`for` は無く全 OS 共通です。`cd` の行き先が `~` か `~/` で始まるとき、yazi はどの OS でもホーム(Windows では `C:\Users\<ユーザー名>`)に置き換えます。Windows での行き先は確かめていません

元は v26.9.1 のソースの `yazi-shared/src/shell/unix.rs`(分割器)、`yazi-shared/src/event/cmd.rs`(`run` の解析)、`yazi-fs/src/path/expand.rs`(変数の展開)、`yazi-fs/src/engine/local/absolute.rs`(`~` の置き換え)、`yazi-config/src/platform.rs`(`for` の値)です。Linux で確かめた範囲は[検証記録](../verification/readme.md)にあります。
