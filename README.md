# つんどく📚 ~ radio

hugoで構築したシンプルウェブページ。

## 環境構築

`git submodule`でhugoのテーマを管理しているため、次のコマンドで取得すること。

```bash
# 初回のcloneのとき
git clone --recursive https://github.com/dorodango-maker/tsundoku-radio.git 

# recursiveを忘れたとき
git submodule update
```

ローカルでの動作には`hugo`は必須なので、次のコマンドでインストールすること。

```bash
brew install hugo
```

hugoはbrewとかでインストールしてくれていればよいけど、nixとdirenvをセットアップしておけば、ディレクトリに入っただけで、依存ツール群のインストールまで一発で完結する。
