# Documentation

🌐 [English](README.md) | 日本語

このディレクトリには、ルートの `README.md` に詰め込みすぎないための詳細ドキュメントを
まとめています。

プロジェクトの概要を素早く確認したい場合はルート README を参照し、現在の仕様、
API契約、デザインルール、公開リポジトリ運用の方針を確認したい場合はこの docs を参照します。

## miniHome documents

- [プロダクト仕様と画面遷移](minihome-product-spec.ja.md)
- [Mockoon API contract](minihome-api.md)
- [Design system](minihome-design-system.md)
- [セキュリティと公開リポジトリ運用](security.ja.md)

## 現在の方針

miniHome は、feature単位の Flutter 構成で作成したコンパクトなスマートホーム
ポートフォリオアプリです。

プロジェクトの基本方針:

- 英語を既定言語、日本語を第二言語とする。
- ローカル開発では Mockoon がデモAPIレスポンスを提供する。
- Firebase Core と Remote Config は利用可能にし、Firebase Auth と Firestore は
  今後の拡張として扱う。
- QR / カメラ登録と Bluetooth を使ったメンテナンス導線を維持する。
- 最初の対象デバイスはライトとエアコンとする。

## ローカルセットアップ

Flutter SDK は FVM で管理します。

```sh
fvm install 3.44.0
fvm use 3.44.0
fvm flutter doctor -v
fvm flutter pub get
```

ローカル実行用の設定ファイルを作成します。

```sh
cp config/app_config.example.json config/app_config.local.json
```

`config/app_config.local.json` は Git 管理対象外です。ローカルの API / Firebase 値は
このファイルに設定します。

Mockoon のみでローカル開発する場合は、local config で Firebase を無効にします。

```json
{
  "ENABLE_FIREBASE": false
}
```

Mockoon を port `3001` で起動してから、以下を実行します。

```sh
fvm flutter run \
  --flavor homeStaging \
  --dart-define-from-file=config/app_config.local.json
```

VS Code の launch configuration も同じ local config を参照します。

## 開発時の確認コマンド

```sh
fvm dart format <changed_dart_files>
fvm flutter pub run build_runner build --delete-conflicting-outputs
fvm flutter analyze
fvm flutter build ios \
  --simulator \
  --flavor homeStaging \
  --dart-define-from-file=config/app_config.local.json
```

Freezed、JSON serialization、Riverpod の generated provider を変更した場合は、
コード生成を実行します。

## 開発ルール

### State management

- 画面内の局所状態には `flutter_hooks` を優先する。
- 共有状態と依存注入には Riverpod を使う。
- 既存の `riverpod_annotation` / generated provider の書き方に合わせる。
- 明確な理由がない限り、`StatefulWidget` の追加は避ける。

### Models

- immutable な data class には Freezed を使う。
- API model には `json_serializable` を使う。
- `.g.dart` や `.freezed.dart` は手編集しない。
- model / provider 定義を変更した場合は generated file も同期する。

### UI and localization

- 画面や widget にユーザー向け文言を直書きしない。
- 文言は `AppStrings` と `assets/translations/en.json` /
  `assets/translations/ja.json` 経由で追加する。
- 英語と日本語の translation key を揃える。
- 画面専用UIを追加する前に、`lib/core/widgets/` の共通 widget を優先して使う。
- 複数画面で使うもの、または miniHome の design-system primitive になるものだけを
  新しい共通UIとして追加する。

### API access

- screens / widgets から Dio を直接呼ばない。
- APIアクセスは `features/<feature>/repositories` に置く。
- 機能ロジックと状態更新は `features/<feature>/services` に置く。
- endpoint path は `lib/core/constants/api_endpoints.dart` で管理する。
- Mockoon route はアプリが使う path と一致させる。

### Navigation

- `lib/router/router.dart` を route 定義の source of truth とする。
- 戻る操作が必要な導線では `pushNamed` を使う。
- sign-out や account deletion のように履歴を置き換える意図がある場合は `goNamed` を使う。

### Storage and secrets

- access token / refresh token は `flutter_secure_storage` に保存する。
- `SharedPreferences` は機密ではない軽量なローカル状態にのみ使う。
- local Firebase file、署名キー、実トークン、実ユーザーデータ、本番デバイスIDは
  コミットしない。

公開リポジトリ向けのチェックリストは [security.ja.md](security.ja.md) を参照してください。
