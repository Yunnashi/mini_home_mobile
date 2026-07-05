# miniHome

miniHomeは、スマートライトとエアコンを管理するポートフォリオ向けの
Flutterスマートホームアプリです。

現在は既存アプリの技術基盤を活かしながら、miniHomeのブランド、ドメイン、
画面デザインへ段階的に移行しています。

## 技術概要

- Flutter 3.44.0 / Dart 3.12.0
- Xcode 26.3
- Riverpod / Hooks / Freezed
- go_router
- Dio / Retrofit
- Firebase
- Mockoon

アプリのエントリポイントは`lib/main.dart`です。

## セットアップ

Flutter SDKはFVMで管理します。

```sh
fvm install 3.44.0
fvm use 3.44.0
fvm flutter doctor -v
fvm flutter pub get
```

## ローカル設定

公開リポジトリにはAPIキーやFirebase設定を保存しません。
exampleファイルをコピーして、ローカル設定を作成してください。

```sh
cp config/app_config.example.json config/app_config.local.json
```

`config/app_config.local.json`に、自分のminiHome用Firebaseプロジェクトの値を設定します。
このファイルはGit管理対象外です。

Mockoonのみで起動する間は`ENABLE_FIREBASE`を`false`にします。
miniHome用Firebaseプロジェクトを接続した後に`true`へ変更してください。

VS Codeでは`.vscode/launch.json`のminiHome構成を選択して起動できます。
各構成も同じローカル設定ファイルを参照します。

## 起動

Mockoonをポート`3001`で起動してから、次のコマンドを実行します。

```sh
fvm flutter run \
  --flavor homeStaging \
  --dart-define-from-file=config/app_config.local.json
```

## 確認

```sh
fvm dart format <changed_dart_files>
fvm flutter analyze
fvm flutter build ios \
  --simulator \
  --flavor homeStaging \
  --dart-define-from-file=config/app_config.local.json
```

## ドキュメント

- [開発ドキュメント](docs/README.md)
- [miniHomeプロダクト仕様](docs/minihome-product-spec.md)
- [Mockoon API仕様](docs/minihome-api.md)
- [セキュリティと公開リポジトリ運用](docs/security.md)

## 秘密情報

次のファイルはコミットしないでください。

- `config/app_config.local.json`
- `GoogleService-Info*.plist`
- `google-services.json`
- `*.jks` / `*.keystore`
- `*key.properties`
- `ExportOptions*.plist`

詳しくは[セキュリティ方針](docs/security.md)を参照してください。
