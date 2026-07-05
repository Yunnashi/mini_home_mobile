# docs/README.md

この `docs/` は、`AGENTS.md` やルート `README.md` に載せすぎないための詳細ドキュメント置き場です。

- `README.md`: セットアップ・起動・ビルドの入口
- `AGENTS.md`: エージェント向けの最小ガードレール
- `docs/`: 設計詳細、背景、開発ルール、運用メモ

## このドキュメントの役割

- 現在の実装方針をまとめる
- 詳細な開発ルールを置く
- 将来の設計資料や仕様書の入口にする

## miniHome

- [プロダクト仕様・画面遷移](minihome-product-spec.md)
- [Mockoon API仕様](minihome-api.md)
- [セキュリティと公開リポジトリ運用](security.md)

miniHomeへの移行では、上記2文書をMVPの仕様とAPI契約の入口として扱う。
Firebase Authentication、Firestore、外部IDログインは将来拡張とし、MVPでは
Mockoonを使って既存のHTTP・repository構成を維持する。

## 現在の開発ルール

### 状態管理

- ローカル状態は `flutter_hooks` ベースを優先する
- `StatefulWidget` は原則使わない
- アプリ全体で共有する状態は `riverpod` を使う
- Provider 定義は `riverpod_annotation` / `riverpod_generator` の既存パターンに合わせる

関連パッケージ:

- `flutter_hooks`
- `flutter_riverpod`
- `hooks_riverpod`
- `riverpod_annotation`
- `riverpod_generator`
- `build_runner`

実装例:

- ローカル状態管理 (`flutter_hooks`)

```dart
import 'package:flutter_hooks/flutter_hooks.dart';

class CounterWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final count = useState(0);

    return Column(
      children: [
        Text('count: ${count.value}'),
        ElevatedButton(
          onPressed: () => count.value++,
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

- グローバル状態管理 (`riverpod` + generator)

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_provider.g.dart';

@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;
}
```

- 利用側

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('count: $count');
  }
}
```

### モデル定義

- イミュータブルなデータクラスは `freezed` を使う
- JSON シリアライズが必要なモデルは `json_serializable` の既存パターンに合わせる
- `part '*.g.dart'` / `part '*.freezed.dart'` を持つファイルでは生成ファイルとの整合を保つ

関連パッケージ:

- `freezed`
- `freezed_annotation`
- `json_serializable`
- `build_runner`

実装例:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

### コード生成

Provider、Freezed、Retrofit に関わる変更ではコード生成を実行すること。

```sh
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

注意:

- `.g.dart` と `.freezed.dart` は手編集しない
- `part` ディレクティブのファイル名は既存命名に合わせる

### Validation / フォーム

- 入力検証は既存の `lib/utils/validate_text.dart` と `lib/utils/password_validator_service.dart` を優先する
- メール形式、必須入力、関連項目一致などの基本検証は既存 validator を再利用する
- バリデーションエラー文言も画面へ直書きせず、`AppStrings` / translation resource を使う

### HTTP / API

- API 通信は `lib/core/network/dio_client.dart` を起点にする
- repository 層から `DioClient.sendRequest` を利用し、widget や screen から直接 `Dio` を叩かない
- 認証付き API では `isLoggedInContent` を正しく指定する
- 通信エラーの扱いとトークン更新は既存の network 層に合わせる
- endpoint は `lib/core/constants/api_endpoints.dart` に集約する
- API から返る `errorCode` で分岐が必要なら `lib/core/constants/api_errors.dart` に追加する
- アプリ独自のエラーコードやメッセージは `lib/core/constants/custom_errors.dart` に追加する

実装例:

```dart
await _dioClient.sendRequest(
  resourcePath: ApiEndpoints.signIn,
  method: HttpMethod.post,
  isLoggedInContent: false,
  body: {
    'user': {
      'email': email,
      'password': password,
    }
  },
  successCallback: (data) {
    response = Success(data);
  },
  errorCallback: (message, code) {
    response = Failure(message, code: code);
  },
);
```

### Storage

- アクセストークンやリフレッシュトークンなど機密情報は `flutter_secure_storage` を使う
- ユーザー情報や更新ダイアログ状態などの軽量ローカル状態は `SharedPreferences` を使う
- storage key は `lib/core/constants/storage_keys.dart` に集約し、文字列を分散して増やさない

### ナビゲーション

- 画面遷移は `go_router` を利用する
- ルーティングの source of truth は `lib/router/router.dart`
- 戻る導線が必要な画面では `pushNamed` を優先する
- 認証状態切り替えなど履歴を残さない遷移では `goNamed` を検討する

例:

```dart
context.pushNamed(AppRoutes.signUp);
context.goNamed(AppRoutes.signUp);
```

使い分け:

- `pushNamed`: 詳細画面、設定画面、戻ることを想定している遷移
- `goNamed`: ログイン後ホーム遷移、ログアウト後初期画面、履歴を残したくない遷移

### Localization / 文言管理

- 表示文言、ラベル、エラーメッセージは画面や widget に直接書かない
- `easy_localization` と `AppStrings` を経由して translation resource から取得する
- 文言追加時は、必要な翻訳キーを `assets/translations/` に追加し、既存のキー命名に合わせる
- 規約、プライバシーポリシー、FAQ は翻訳リソースのローカル本文を表示し、外部URLへ依存しない

実装例:

```dart
static String get titleSignIn => "settings.signin.title".tr();
```

```dart
Text(AppStrings.titleSignIn)
```

### 権限 / カメラ / QR

- カメラ権限は `lib/utils/permission_service.dart` を起点に扱う
- QR 読み取りは `mobile_scanner` と既存の device registration フローに合わせる
- 権限追加や変更時は Dart 実装だけで完結させず、iOS と Android のネイティブ設定も確認する
- iOS では `ios/Podfile` の permission macro 設定を確認する
- Android では `AndroidManifest.xml` と必要な platform 設定を確認する

### Environment / Flavor

- API host、API key、FAQ / 規約 URL、QR 判定用正規表現、ストア URL は `lib/environment/` を source of truth とする
- 画面、service、repository に環境依存値を直書きしない
- flavor 追加や設定変更は `AppConfig`、`environment.dart`、各 flavor ディレクトリをまとめて確認する

### Observability

- 重要な例外や通信障害は既存のロガーを通して記録する
