# セキュリティと公開リポジトリ運用

🌐 [English](security.md) | 日本語

miniHome は公開ポートフォリオリポジトリとして扱う想定です。Git履歴には、
認証情報、署名関連ファイル、実ユーザーデータ、非公開のプロジェクト識別子を
含めないようにします。

## コミットしないもの

- ローカル実行用の設定ファイル
- `.env` ファイルや派生した環境設定ファイル
- Firebase のネイティブ設定ファイル
- Android の署名キーと key properties
- Apple 配布用の `ExportOptions` ファイル
- 実際の access token、refresh token、password、API secret
- 実ユーザーの email、電話番号、住所、デバイス識別子

ignore 対象の source of truth はルートの `.gitignore` です。

## Runtime configuration

公開しても問題ない設定キーは `config/app_config.example.json` にまとめます。

ローカル値は以下に保存します。

```text
config/app_config.local.json
```

アプリは以下のように起動します。

```sh
fvm flutter run \
  --flavor homeStaging \
  --dart-define-from-file=config/app_config.local.json
```

Mockoon のみで動かす場合、local API key は空にし、local config で Firebase を無効にします。
デモの Mockoon フローでは、非公開の Firebase 値がなくても起動できる状態を保ちます。

## Firebase

Firebase のクライアント設定は、それ自体がセキュリティ境界ではありません。

実際の Firebase project を接続する前に、以下を確認します。

- miniHome 専用の Firebase project を使う。
- データ保存前に Firestore Security Rules を設定する。
- Authentication の authorized domains を制限する。
- 準備ができた段階で App Check を有効にする。
- service account private key をアプリやリポジトリに保存しない。

## Mockoon data

`mockoon.json` には架空データのみを含めます。

- 明らかに fake とわかる token を使う。
- 実在する email address を使わない。
- 本番 device ID を使わない。
- 本番 API response をそのままコピーしない。

## Pre-commit checklist

```sh
git status --short --untracked-files=all
git diff --cached
rg -n -i 'api[_-]?key|client[_-]?secret|private[_-]?key|access[_-]?token|refresh[_-]?token|password'
```

誤って secret をコミットした場合、後続コミットでファイルを削除するだけでは不十分です。
公開前に Git 履歴から secret を削除し、漏洩した key / token は rotate または revoke します。
