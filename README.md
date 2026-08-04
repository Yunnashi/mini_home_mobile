# miniHome

<p align="center">
  <img src="assets/branding/mini_home/images/splash.png" alt="miniHome logo" width="320">
</p>

miniHome is a Flutter smart-home app for managing connected home devices, such
as lights and air conditioners. I designed and implemented it from scratch as a
portfolio project to explore how a clean mobile UI, typed data models, and
API-driven state management can work together in a practical app.

The app is intentionally small in scope, but it includes the kinds of screens
that appear in many real products: authentication, a dashboard, device details,
settings, schedules, activity history, and error/offline states.

## Why I created this app

I created miniHome to demonstrate my Flutter development skills through a theme
that is easy to understand at a glance.

Smart-home apps look simple, but they involve many common mobile development
problems:

- showing a list of remote data;
- updating device state from the UI;
- handling loading, empty, error, and offline states;
- switching the UI based on data type;
- keeping screen code separate from API access;
- supporting multiple languages.

Through this project, I focused on three things: choosing practical technologies,
building a feature-based architecture, and designing a UI that is easy to use in
daily smart-home scenarios.

## What I focused on

- **New app design and implementation**: I designed the product theme, screen
  structure, device domain, and UI direction as a new Flutter app.
- **Technology selection and architecture**: I chose Riverpod for predictable
  state management and Freezed for immutable models. I also organized the code
  by feature, with `models`, `repositories`, and `services` kept close to each
  domain.
- **UI/UX design and shared components**: I designed a clean smart-home
  interface with readable cards, clear online/offline states, quick power
  controls, and reusable UI components based on shared design tokens.
- **API-driven development**: I used Mockoon to build the app against realistic
  HTTP responses, including loading, empty, error, offline, and update states.
- **Localization**: I made English the default language and added Japanese
  support with `easy_localization`. User-facing text is managed through
  `AppStrings` instead of being hard-coded in widgets.
- **QR, Bluetooth, and permissions**: I implemented mobile-native flows such as
  QR code scanning with the camera, runtime permission handling, and
  Bluetooth-based device maintenance actions.

## Features

- Email/password authentication flow.
- Home dashboard with room filters.
- Light and air-conditioner device cards.
- Power control from the device list.
- Type-specific device detail screens.
- Light brightness and color-temperature controls.
- Air-conditioner temperature, mode, and fan-speed controls.
- Schedule list, create, edit, enable/disable, and delete flows.
- Activity history screen.
- Device settings with name, room, firmware update, reboot, and delete actions.
- QR-based device registration flow.
- English-first localization with Japanese support.

## UI design

<p align="center">
  <img src="docs/images/minihome-ui-overview.png" alt="miniHome UI overview" width="1200">
</p>

The UI is inspired by modern smart-home apps: bright backgrounds, rounded cards,
clear status labels, and compact controls.

I tried to keep the design simple enough for a portfolio reviewer to understand
quickly, while still making the app feel like a real product. Device cards show
the most important information first, and each detail screen changes its
controls based on the device type.

The design tokens and component rules are documented in
[docs/minihome-design-system.md](docs/minihome-design-system.md).

## Language and libraries

- Flutter 3.44.0 / Dart 3.12.0
- Riverpod / Hooks
- Freezed / json_serializable
- go_router
- Dio
- Firebase Core / Remote Config
- Mockoon
- easy_localization

I use Riverpod to keep app state and feature logic outside the UI layer. Freezed
and JSON serialization help keep API models predictable, and Mockoon makes it
possible to develop the app with realistic API responses before connecting a
real backend.

## Architecture

The app is organized by responsibility:

```text
lib/
├── core/                     # Shared UI, theme, networking, constants
├── environment/              # Flavor and runtime configuration
├── features/
│   └── <feature>/
│       ├── models/           # Freezed models and JSON mapping
│       ├── repositories/     # API/storage access
│       └── services/         # Use cases and Riverpod state
├── router/                   # go_router definitions
├── screens/                  # Screen-level UI
└── utils/                    # Cross-cutting utilities
```

Screens do not call Dio directly. API access goes through repositories, while
feature behavior and state updates live in services. This structure keeps the UI
focused on rendering and user interaction.

<p align="center">
  <img src="docs/images/minihome-architecture-overview.png" alt="miniHome architecture overview" width="1200">
</p>

For device data, the Home and Device Detail screens use a lightweight polling
strategy. They refresh data every 30 seconds only while the screen is visible,
stop polling when the app goes inactive or the user navigates away, and avoid
showing loading indicators during background refreshes.

## How to run

The app runs locally with FVM and Mockoon. Detailed setup and development
commands are documented in [docs/README.md](docs/README.md).

In short, create `config/app_config.local.json` from the example file, start
Mockoon on port `3001`, and run the `homeStaging` flavor with
`--dart-define-from-file=config/app_config.local.json`.

## Demo API

The app uses Mockoon for local API responses. API details are documented in
[docs/minihome-api.md](docs/minihome-api.md).

The demo data is fictional. Real users, tokens, device IDs, Firebase files, and
signing assets should never be committed.

## Documentation

- [docs/README.md](docs/README.md)
- [Product specification and navigation](docs/minihome-product-spec.md)
- [Mockoon API contract](docs/minihome-api.md)
- [Design system](docs/minihome-design-system.md)
- [Security and public repository policy](docs/security.md)

## Security note

This repository is intended to be public. The following files must not be
committed:

- `config/app_config.local.json`
- `GoogleService-Info*.plist`
- `google-services.json`
- `*.jks` / `*.keystore`
- `*key.properties`
- `ExportOptions*.plist`

See [docs/security.md](docs/security.md) for the full policy.
