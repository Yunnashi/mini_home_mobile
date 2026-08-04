# Documentation

🌐 English | [日本語](README.ja.md)

This directory contains the detailed documentation that should not be crowded
into the root `README.md`.

Use the root README for a quick project overview and setup instructions. Use
these documents when you need the current product scope, API contract, design
rules, or public-repository policy.

## miniHome documents

- [Product specification and navigation](minihome-product-spec.md) / [日本語](minihome-product-spec.ja.md)
- [Mockoon API contract](minihome-api.md)
- [Design system](minihome-design-system.md)
- [Security and public repository policy](security.md) / [日本語](security.ja.md)

## Current direction

miniHome is a compact smart-home portfolio app built with a feature-based
Flutter structure.

Project principles:

- English is the default locale; Japanese is the secondary locale.
- Mockoon provides demo API responses for local development.
- Firebase Core and Remote Config are available, while Firebase Auth and
  Firestore are planned as future work.
- QR/camera registration and Bluetooth-based maintenance flows are supported.
- Lights and air conditioners are the first supported device types.

## Local setup

Flutter is managed with FVM.

```sh
fvm install 3.44.0
fvm use 3.44.0
fvm flutter doctor -v
fvm flutter pub get
```

Create a local runtime config:

```sh
cp config/app_config.example.json config/app_config.local.json
```

`config/app_config.local.json` is intentionally ignored by Git. Use it for local
API/Firebase values.

For local development with Mockoon, keep Firebase disabled in the local config:

```json
{
  "ENABLE_FIREBASE": false
}
```

Start Mockoon on port `3001`, then run:

```sh
fvm flutter run \
  --flavor homeStaging \
  --dart-define-from-file=config/app_config.local.json
```

VS Code launch configurations also read the same local config file.

## Development checks

```sh
fvm dart format <changed_dart_files>
fvm flutter pub run build_runner build --delete-conflicting-outputs
fvm flutter analyze
fvm flutter build ios \
  --simulator \
  --flavor homeStaging \
  --dart-define-from-file=config/app_config.local.json
```

Run code generation whenever Freezed, JSON serialization, or Riverpod generated
providers are changed.

## Development rules

### State management

- Prefer `flutter_hooks` for local screen state.
- Use Riverpod for shared state and dependency injection.
- Follow the project `riverpod_annotation` / generated provider style.
- Avoid adding `StatefulWidget` unless there is a clear reason.

### Models

- Use Freezed for immutable data classes.
- Use `json_serializable` for API models.
- Do not hand-edit `.g.dart` or `.freezed.dart` files.
- Keep generated files in sync when model/provider definitions change.

### UI and localization

- Do not hard-code user-facing copy in screens or widgets.
- Add strings through `AppStrings` and `assets/translations/en.json` /
  `assets/translations/ja.json`.
- Keep English and Japanese translation keys aligned.
- Reuse shared widgets from `lib/core/widgets/` before adding screen-local UI.
- Add new shared UI only when it is useful across more than one screen or
  represents a miniHome design-system primitive.

### API access

- Screens and widgets must not call Dio directly.
- API access belongs in `features/<feature>/repositories`.
- Feature behavior and state updates belong in `features/<feature>/services`.
- Endpoint paths belong in `lib/core/constants/api_endpoints.dart`.
- Mockoon routes should match the same paths used by the app.

### Navigation

- `lib/router/router.dart` is the source of truth for routes.
- Use `pushNamed` for flows where the user should be able to go back.
- Use `goNamed` when replacing navigation history is intentional, such as after
  sign-out or account deletion.

### Storage and secrets

- Store access/refresh tokens in `flutter_secure_storage`.
- Use `SharedPreferences` only for non-sensitive local state.
- Never commit local Firebase files, signing keys, real tokens, real user data,
  or production device identifiers.

See [security.md](security.md) for the full public repository checklist.
