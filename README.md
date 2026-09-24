# miniHome

🌐 English | [日本語](README.ja.md)

<p align="center">
  <img src="assets/branding/mini_home/images/splash.png" alt="miniHome logo" width="320">
</p>

<p align="center">
  A Flutter smart-home app for controlling connected home devices.
</p>

<p align="center">
  <img src="docs/images/minihome-ui-overview.png" alt="miniHome UI overview" width="1200">
</p>

> Built from scratch with a focus on clean UI/UX, scalable architecture, and realistic API-driven interactions.

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
- **QR, camera, and permissions**: I implemented mobile-native flows such as
  QR code scanning with the camera and runtime permission handling.

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

The UI is inspired by modern smart-home apps: bright backgrounds, rounded cards,
clear status labels, and compact controls.

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

## Demo API

The app uses Mockoon for local API responses. API details are documented in
[docs/minihome-api.md](docs/minihome-api.md).

The demo data is fictional. Real users, tokens, device IDs, Firebase files, and
signing assets should never be included.

See [docs/security.md](docs/security.md) for the full policy.

## Documentation

- [docs/README.md](docs/README.md) / [日本語](docs/README.ja.md)
- [Product specification and navigation](docs/minihome-product-spec.md) / [日本語](docs/minihome-product-spec.ja.md)
- [Mockoon API contract](docs/minihome-api.md)
- [Design system](docs/minihome-design-system.md)
- [Security and public repository policy](docs/security.md) / [日本語](docs/security.ja.md)


