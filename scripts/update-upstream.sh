#!/usr/bin/env bash
# 上流 yazi の既定設定(yazi-config/preset/)を取得して main ブランチに積む。
# 作業ツリーや index には触れない(plumbing だけで main にコミットを作る)。
# 使い方: bash scripts/update-upstream.sh [vX.Y.Z]   (省略時: インストール済み yazi の版)
set -euo pipefail

REPO=$(git rev-parse --show-toplevel)
BRANCH=main
BASE_URL=https://raw.githubusercontent.com/sxyazi/yazi
# 上流 preset のファイル名 : このリポジトリでのファイル名
MAP=(
  "yazi-default.toml:yazi.toml"
  "keymap-default.toml:keymap.toml"
  "theme-dark.toml:theme.toml"
  "vfs-default.toml:vfs.toml"
)

TAG=${1:-}
if [[ -z $TAG ]]; then
  TAG=$(yazi --version | sed -n 's/^[[:space:]]*Version:[[:space:]]*\([0-9][0-9.]*\).*/v\1/p')
  [[ -n $TAG ]] || { echo "yazi --version を解釈できない。タグを引数で渡す" >&2; exit 1; }
fi
[[ $TAG == v* ]] || TAG="v$TAG"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
# 一時 index を使うので、本物の index と作業ツリーは変わらない
export GIT_INDEX_FILE="$TMP/index"

for pair in "${MAP[@]}"; do
  src=${pair%%:*}
  dst=${pair##*:}
  # 存在しないタグなら -f で失敗し、ref に触れる前に中断する
  curl -fsSL "$BASE_URL/$TAG/yazi-config/preset/$src" -o "$TMP/$dst"
  blob=$(git -C "$REPO" hash-object -w "$TMP/$dst")
  git -C "$REPO" update-index --add --cacheinfo "100644,$blob,$dst"
done
tree=$(git -C "$REPO" write-tree)

if git -C "$REPO" show-ref --verify --quiet "refs/heads/$BRANCH"; then
  if [[ $tree == $(git -C "$REPO" rev-parse "$BRANCH^{tree}") ]]; then
    commit=$(git -C "$REPO" rev-parse "$BRANCH")
    echo "presets unchanged at $TAG"
  else
    commit=$(git -C "$REPO" commit-tree "$tree" -p "$BRANCH" -m "Update upstream presets to $TAG")
    git -C "$REPO" update-ref "refs/heads/$BRANCH" "$commit"
  fi
else
  # main が無ければ、履歴を持たない orphan ブランチとして作る
  commit=$(git -C "$REPO" commit-tree "$tree" -m "Import upstream presets $TAG")
  git -C "$REPO" update-ref "refs/heads/$BRANCH" "$commit"
fi

# 既にタグがある場合はそのまま
git -C "$REPO" tag -a "upstream/$TAG" -m "yazi presets $TAG" "$commit" 2>/dev/null || true
echo "$BRANCH: $(git -C "$REPO" rev-parse --short "$BRANCH") (tag upstream/$TAG)"
echo "next: git rebase $BRANCH custom"
