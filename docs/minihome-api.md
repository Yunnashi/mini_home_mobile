# miniHome Mockoon API contract

## 1. Purpose

This document defines the API contract between the miniHome Flutter app and the
Mockoon demo server.

The app uses Mockoon instead of a custom backend for local development. Flutter
talks to the API through repositories, so the same screen and service structure
can work with Firebase Auth / Firestore in the future.

## 2. Base rules

- Base URL: `http://localhost:3001`
- API prefix: `/v1`
- Content-Type: `application/json`
- JSON fields: lower camel case
- Datetime format: ISO 8601, for example `yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ`
- ID format: integers for the current demo API
- Success responses: `2xx`
- Validation error: `400`
- Unauthorized: `401`
- Not found: `404`
- Conflict: `409`
- Server error: `500`

When running from a physical device or Android Emulator, change the host in the
local app config as needed.

## 3. Authentication

Mockoon returns a fixed demo user and fake tokens.

| Method | Path | Purpose |
| --- | --- | --- |
| POST | `/v1/auth/sign-up` | Create a demo account |
| POST | `/v1/auth/sign-in` | Sign in |
| POST | `/v1/auth/refresh` | Refresh token |
| PATCH | `/v1/auth/password` | Change password |
| POST | `/v1/auth/password/reset` | Request password reset |
| POST | `/v1/auth/verification/resend` | Resend verification email |
| DELETE | `/v1/account` | Delete account |

The signed-in user must include:

```json
{
  "id": 1,
  "email": "demo@minihome.app",
  "defaultHomeId": 1
}
```

The auth response should use `defaultHomeId` as the entry point to home data.

## 4. Home

### Get home

`GET /v1/homes/:homeId`

```json
{
  "id": 1,
  "name": "My Home",
  "rooms": [
    { "id": 1, "name": "Living room", "displayOrder": 1 },
    { "id": 2, "name": "Bedroom", "displayOrder": 2 }
  ],
  "summary": {
    "activeDeviceCount": 2,
    "indoorTemperature": 27,
    "todayEnergyKwh": 4.8
  }
}
```

The demo user's default home is `1`.

## 5. Devices

### List devices

`GET /v1/homes/:homeId/devices`

Optional query:

| Name | Required | Description |
| --- | --- | --- |
| `roomId` | No | Return only devices in the selected room |

```json
{
  "devices": [
    {
      "id": 1,
      "externalDeviceId": "MH-LIGHT-001",
      "homeId": 1,
      "roomId": 1,
      "name": "Living room light",
      "type": "light",
      "isOnline": true,
      "isPowerOn": true,
      "lightState": {
        "brightness": 70,
        "colorTemperature": 4200
      },
      "airConditionerState": null,
      "fwVersion": "1.0.0",
      "lastPingedAt": "2026-08-04T20:00:00.000+0900"
    },
    {
      "id": 2,
      "externalDeviceId": "MH-AC-001",
      "homeId": 1,
      "roomId": 1,
      "name": "Living room AC",
      "type": "airConditioner",
      "isOnline": true,
      "isPowerOn": false,
      "lightState": null,
      "airConditionerState": {
        "targetTemperature": 24,
        "mode": "cooling",
        "fanSpeed": "auto"
      },
      "fwVersion": "1.0.0",
      "lastPingedAt": "2026-08-04T20:00:00.000+0900"
    }
  ]
}
```

### Get device

`GET /v1/homes/:homeId/devices/:deviceId`

The response uses the same device shape as the list endpoint.

### Add device by QR scan

`POST /v1/homes/:homeId/devices/scan`

The app supports QR/camera registration. The scanned value is sent as
`encryptedDeviceId`.

```json
{
  "encryptedDeviceId": "demo-encrypted-device-id"
}
```

Mockoon returns a demo device. Bluetooth-related maintenance code must not be
deleted; it is used by the device reboot flow.

### Update common device fields

`PATCH /v1/homes/:homeId/devices/:deviceId`

Power update:

```json
{
  "isPowerOn": true
}
```

Metadata update:

```json
{
  "name": "Sofa light",
  "roomId": 1
}
```

Return the updated device.

### Update light state

`PATCH /v1/homes/:homeId/devices/:deviceId/light-state`

```json
{
  "brightness": 60,
  "colorTemperature": 3800
}
```

Validation:

- `brightness`: `0` to `100`
- `colorTemperature`: `2700` to `6500`

### Update air-conditioner state

`PATCH /v1/homes/:homeId/devices/:deviceId/air-conditioner-state`

```json
{
  "targetTemperature": 25,
  "mode": "cooling",
  "fanSpeed": "auto"
}
```

Validation:

- `targetTemperature`: `16` to `30`
- `mode`: `auto`, `cooling`, `heating`, `fan`
- `fanSpeed`: `auto`, `low`, `medium`, `high`

### Request firmware update

`PATCH /v1/homes/:homeId/devices/:deviceId/fw-update`

Firmware update is treated as a generic smart-device maintenance feature.

### Fetch reboot OTP

`POST /v1/homes/:homeId/devices/:deviceId/reboot-otp`

```json
{
  "deviceChallenge": "base64-device-challenge"
}
```

The app uses Bluetooth to write the returned OTP to the device.

### Delete device

`DELETE /v1/homes/:homeId/devices/:deviceId`

Return `204` with an empty body.

## 6. Schedules

### List schedules

`GET /v1/homes/:homeId/devices/:deviceId/schedules`

```json
{
  "schedules": [
    {
      "id": 1,
      "deviceId": 1,
      "name": "Weekday morning",
      "startAt": "0700",
      "finishAt": "0830",
      "weekdays": ["mon", "tue", "wed", "thu", "fri"],
      "isEnabled": true,
      "action": {
        "isPowerOn": true
      }
    }
  ]
}
```

### Create schedule

`POST /v1/homes/:homeId/devices/:deviceId/schedules`

### Update schedule

`PATCH /v1/homes/:homeId/devices/:deviceId/schedules/:scheduleId`

### Toggle schedule

`PATCH /v1/homes/:homeId/devices/:deviceId/schedules/:scheduleId/enabled`

```json
{
  "isEnabled": false
}
```

### Delete schedule

`DELETE /v1/homes/:homeId/devices/:deviceId/schedules/:scheduleId`

## 7. Activity history

`GET /v1/homes/:homeId/devices/:deviceId/usages`

```json
{
  "usages": [
    {
      "id": 1,
      "activity": "Power on",
      "startedAt": "2026-08-04T18:30:00.000+0900",
      "finishedAt": "2026-08-04T20:00:00.000+0900",
      "durationSeconds": 5400
    }
  ]
}
```

Activity history uses generic smart-home names such as `activity` and
`durationSeconds`.

## 8. Error response

Use one error shape across API responses:

```json
{
  "statusCode": 404,
  "message": "Device not found",
  "error": "Not Found",
  "errorCode": "MH_DEVICE_404"
}
```

Mockoon should keep error fixtures available as separate responses or routes.
Normal device-control responses should succeed so the portfolio demo remains
easy to operate.
