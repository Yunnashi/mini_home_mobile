# miniHome Mockoon API仕様

## 1. 目的

この文書は、miniHome MVPで使用するMockoon APIとFlutterアプリ間の契約を定義する。

MVPではAPIをMockoonで提供するが、Flutter側は通常のrepository経由でアクセスする。
将来Firestoreへ移行する際も、画面とserviceの公開インターフェースは維持する。

## 2. 基本仕様

- Base URL: `http://localhost:3001`
- API prefix: `/v1`
- Content-Type: `application/json`
- JSONのフィールド名: lower camel case
- 日時: ISO 8601
- ID: MVPでは整数
- 成功レスポンス: `2xx`
- 入力エラー: `400`
- 未認証: `401`
- 対象なし: `404`
- 競合: `409`
- サーバーエラー: `500`

実機やAndroid Emulatorから利用する場合は、実行環境に応じてホストを変更する。

## 3. 認証API

認証は機能移行の対象外とし、当面は既存エンドポイントを維持する。

| Method | Path | 用途 |
| --- | --- | --- |
| POST | `/v1/users/registration` | サインアップ |
| POST | `/v1/users/sign-in` | サインイン |
| POST | `/v1/users/refresh-token` | トークン更新 |
| PATCH | `/v1/users/password` | パスワード変更 |

Mockoonでは固定のデモユーザーとトークンを返す。実在するメールアドレス、
パスワード、アクセストークンは保存しない。

## 4. Home

### ホーム詳細取得

`GET /v1/homes/:homeId`

```json
{
  "id": 1,
  "name": "わたしの家",
  "rooms": [
    { "id": 1, "name": "リビング", "displayOrder": 1 },
    { "id": 2, "name": "寝室", "displayOrder": 2 }
  ]
}
```

MVPではログインユーザーの既定ホームIDを`1`として扱う。

## 5. Device

### デバイス一覧取得

`GET /v1/homes/:homeId/devices`

Query:

| Name | Required | Description |
| --- | --- | --- |
| `roomId` | No | 指定した部屋のデバイスだけを返す |

```json
{
  "devices": [
    {
      "id": 1,
      "homeId": 1,
      "roomId": 1,
      "name": "リビングライト",
      "type": "light",
      "isOnline": true,
      "isPowerOn": true,
      "lightState": {
        "brightness": 70,
        "colorTemperature": 4200
      },
      "airConditionerState": null
    },
    {
      "id": 2,
      "homeId": 1,
      "roomId": 1,
      "name": "リビングエアコン",
      "type": "airConditioner",
      "isOnline": true,
      "isPowerOn": false,
      "lightState": null,
      "airConditionerState": {
        "targetTemperature": 24,
        "mode": "cooling",
        "fanSpeed": "auto"
      }
    }
  ]
}
```

### デバイス詳細取得

`GET /v1/homes/:homeId/devices/:deviceId`

レスポンスのデバイス形式は一覧と共通とする。

### デバイス追加

`POST /v1/homes/:homeId/devices`

```json
{
  "name": "寝室ライト",
  "type": "light",
  "roomId": 2
}
```

成功時は作成されたデバイスを返し、ステータスは`201`とする。

Mockoonでは実機探索を行わず、選択した種類に応じたデモデバイスを返す。

### デバイス共通状態更新

`PATCH /v1/homes/:homeId/devices/:deviceId`

電源状態の変更例:

```json
{
  "isPowerOn": true
}
```

名前と部屋の変更例:

```json
{
  "name": "ソファライト",
  "roomId": 1
}
```

成功時は更新後のデバイスを返す。

### ライト状態更新

`PATCH /v1/homes/:homeId/devices/:deviceId/light-state`

```json
{
  "brightness": 60,
  "colorTemperature": 3800
}
```

制約:

- `brightness`: 0〜100
- `colorTemperature`: 2700〜6500（Kelvin）

### エアコン状態更新

`PATCH /v1/homes/:homeId/devices/:deviceId/air-conditioner-state`

```json
{
  "targetTemperature": 25,
  "mode": "cooling",
  "fanSpeed": "auto"
}
```

制約:

- `targetTemperature`: 16〜30
- `mode`: `auto`, `cooling`, `heating`, `fan`
- `fanSpeed`: `auto`, `low`, `medium`, `high`

### デバイス削除

`DELETE /v1/homes/:homeId/devices/:deviceId`

成功時は本文なしの`204`を返す。

## 6. Schedule

### 一覧取得

`GET /v1/homes/:homeId/devices/:deviceId/schedules`

```json
{
  "schedules": [
    {
      "id": 1,
      "deviceId": 1,
      "name": "平日の朝",
      "time": "07:00",
      "weekdays": ["mon", "tue", "wed", "thu", "fri"],
      "isEnabled": true,
      "action": {
        "isPowerOn": true
      }
    }
  ]
}
```

### 作成

`POST /v1/homes/:homeId/devices/:deviceId/schedules`

### 更新

`PATCH /v1/homes/:homeId/devices/:deviceId/schedules/:scheduleId`

### 有効状態更新

`PATCH /v1/homes/:homeId/devices/:deviceId/schedules/:scheduleId/enabled`

```json
{
  "isEnabled": false
}
```

### 削除

`DELETE /v1/homes/:homeId/devices/:deviceId/schedules/:scheduleId`

## 7. エラーレスポンス

既存のネットワーク層と互換性を保つため、エラー形式を統一する。

```json
{
  "statusCode": 404,
  "message": "Device not found",
  "error": "Not Found",
  "errorCode": "MH_DEVICE_404"
}
```

miniHome用エラーコードは`MH_`を接頭辞とする。

## 8. Mockoon実装ルール

- `mockoon.json`には架空のユーザーとデバイスだけを保存する
- レスポンスはライトとエアコンを最低1台ずつ含める
- オンライン、オフライン、オン、オフの表示確認ができるデータを用意する
- 正常系をdefault responseにする
- 主要APIには`400`、`404`、`500`の確認用レスポンスを用意する
- Flutterモデル変更とMockoonレスポンス変更は同じ実装段階で行う
- `type`は`light`または`airConditioner`とし、他の表記へ変換しない
- MVPではMockoon上の永続性を保証しない

## 9. Firestore移行時の対応

Firestore対応は別のrepository実装として追加する。

```text
DeviceRepository
├── MockDeviceRepository
└── FirestoreDeviceRepository
```

画面はrepositoryの実装方式を意識しない。Firestoreのコレクション設計、
Security Rules、認証ユーザーとの関連付けはFirebase移行フェーズで確定する。
