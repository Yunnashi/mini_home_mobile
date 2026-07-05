# セキュリティと公開リポジトリ運用

## 基本方針

このリポジトリはPUBLICで公開することを前提とする。
認証情報、署名情報、実ユーザーデータ、非公開プロジェクトの識別情報を
Git履歴へ含めない。

## Git管理しないもの

- ローカル用設定JSON
- `.env`とその派生ファイル
- Firebaseネイティブ設定ファイル
- Android署名鍵とkey properties
- Apple配布用ExportOptions
- 実アクセストークン、リフレッシュトークン、パスワード
- 実ユーザーのメールアドレス、電話番号、デバイスID

除外ルールのsource of truthはルートの`.gitignore`とする。

## アプリ設定

公開可能なキー一覧は`config/app_config.example.json`で管理する。
実際の値は`config/app_config.local.json`へ保存し、次の形式で渡す。

```sh
fvm flutter run \
  --flavor homeStaging \
  --dart-define-from-file=config/app_config.local.json
```

Mockoon利用時は`APP_API_KEY`を空文字にする。Dioは空のAPIキーをヘッダーへ
追加しない。

## Firebase

Firebaseのクライアント設定値だけでサービスを保護しない。

- miniHome専用Firebaseプロジェクトを使用する
- Firestore Security Rulesを必ず設定する
- Authenticationの許可ドメインを制限する
- 対応時にApp Checkを有効化する
- サービスアカウント秘密鍵はアプリやリポジトリへ保存しない

## Mockoon

`mockoon.json`には架空データのみを保存する。

- トークンは明確なダミー値を使う
- 実メールアドレスや実デバイスIDを使わない
- 本番APIのレスポンスをそのままコピーしない

## コミット前確認

```sh
git status --short --untracked-files=all
git diff --cached
rg -n -i 'api[_-]?key|client[_-]?secret|private[_-]?key|access[_-]?token|refresh[_-]?token|password'
```

秘密情報を誤ってコミットした場合は、ファイルを削除するだけでは不十分である。
公開前に履歴から除去し、該当するキーやトークンを失効・再発行する。
