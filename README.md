## イメージビルド
docker build -t rust-yew .

## イメージ実行
docker run -it --rm --name rust-app -e TZ=Asia/Tokyo -p 8080:8080 rust-yew

## trunkサーバー起動
trunk serve

### 備忘録
- trunkサーバーはデフォルトで8080番で動作する
- RUNコマンドで必要なファイル類を生成している以上、バインドマウントしづらい…
- ディレクトリだけ作ってローカルの空のディレクトリをバインドマウントして、ファイル生成系のコマンドは後から叩いた方がいいかも

## ビルド時のエラー
- error: failed to run custom build command for `openssl-sys v0.9.72`
- pkg-configやlibssl-dev等のパッケージをインストールして解決

## trunk serve時のエラー
- error[E0463]: can't find crate for `core`
- rustup target add wasm32-unknown-unknown
- で解決


