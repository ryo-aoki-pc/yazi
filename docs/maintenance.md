# yazi 設定の保守

[文書一覧](README.md) / [設定内容・キー操作](reference/readme.md) / [検証記録](verification/readme.md)

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
