# AGENTS.md

`mini_home_mobile` の AI エージェント向け共通ガイドライン。

このファイルは、このリポジトリで安全に作業するための最小限のガードレールと参照先を示す入口として扱うこと。設計詳細や仕様の背景はここに書き込まず、必要に応じて `docs/` に分離する。

## 目的

- このリポジトリで作業する際の最低限のルールを共有する
- source of truth を明示し、推測で構造を変えないようにする
- 詳細な手順や強いハーネスを `AGENTS.md` に詰め込みすぎない

## 適用範囲

- 対象: このリポジトリ全体
- 優先順位: 実装コード > `docs/` > `AGENTS.md` > `README.md`
- ただしセットアップや実行手順は `README.md` を入口とする

## プロジェクト概要

- Flutter / Dart で実装された、個人向け EV 充電器管理アプリ
- アプリのエントリポイントは `lib/main.dart`

## まず参照すべきもの

- `README.md`: セットアップ、起動方法
- `docs/README.md`: 設計・開発ルール・運用メモの入口
- `pubspec.yaml`: 依存関係と利用技術の source of truth
- `lib/main.dart`: アプリ起動処理の入口
- `lib/router/router.dart`: 画面遷移定義の source of truth
- `lib/environment/`: flavor / Firebase / 実行環境設定の source of truth

## ディレクトリ構成

```text
lib/
├── core/                     # 共通 UI、theme、network、constants
├── environment/              # flavor ごとの設定と Firebase 設定
│   ├── home_product/
│   └── home_staging/
├── features/
│   └── <feature>/
│       ├── models/           # ドメインモデル、Freezed モデル
│       ├── repositories/     # API / storage などのデータアクセス
│       └── services/         # ユースケース、状態取得、機能ロジック
├── router/                   # go_router によるルーティング定義
├── screens/
│   └── <page>/
│       └── widgets/          # 画面専用 UI
├── utils/                    # 横断ユーティリティ
└── main.dart                 # エントリポイント
```

補足:

- model, repositories, services は機能ごとに `features/` 配下へまとめる
- 各画面は `screens/` に置く
- 共通 UI や横断ロジックは `core/` と `utils/` を優先する

## 実装ルール

- UI の状態管理は既存方針に合わせ、`StatefulWidget` より Hook ベースを優先する
- アプリ全体で共有する状態や依存注入は Riverpod の既存パターンに合わせる
- 画面文言やエラーメッセージは画面へ直書きせず、`easy_localization` と `AppStrings` を経由する
- 画面追加や遷移変更では、`lib/router/router.dart` を source of truth として更新する
- flavor / Firebase 関連の変更では、`lib/environment/` を起点に影響範囲を確認する
- API 通信は既存の `lib/core/network/` と repository 層を起点にし、画面や widget から直接 `Dio` を扱わない
- 機密情報は `flutter_secure_storage`、軽量なローカル状態は `SharedPreferences` を既存パターンに合わせて使い分ける
- 権限追加や変更では Dart 側だけでなく、iOS と Android のネイティブ設定も確認する
- 既存の責務分割に合わせ、feature ロジックは `models` / `repositories` / `services` に寄せる

## コード生成ファイルの扱い

- `@riverpod`、`freezed`、Retrofit に関わる変更では、生成ファイルとの整合を保つ
- `.g.dart` と `.freezed.dart` は手編集しない
- 生成規約の source of truth は、既存の `part '*.g.dart'` / `part '*.freezed.dart'` を持つ実装と `docs/README.md`

## 作業完了時の確認

- Dart ファイルを変更した場合は、変更した Dart ファイルに対して `dart format <changed_files>` を実行する
- 作業完了前に `fvm flutter analyze` を実行する
- Lint / analyze で `Error` が出た場合は修正してから完了とする
- `Warning` は必須修正ではないが、残っている場合は最終報告で明示する
- 変更内容にコード生成が関わる場合は、必要な生成コマンドも実行したうえで整合を確認する

## docs との分担

- `AGENTS.md` には常時必要な最小ルールだけを残す
- 設計詳細、仕様背景、重い運用手順は `docs/` に分離する
- repo 固有の詳細な実装ガイドは `docs/` 配下で管理する

## docs について

- `docs/README.md` を docs の入口として扱う
- 詳細設計や運用手順を追加する場合は `docs/` 配下へ寄せる
- まだ存在しないドキュメントを前提に実装判断しない
