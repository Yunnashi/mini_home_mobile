# miniHome Design System

miniHome uses a bright, calm visual language for everyday IoT controls. It takes
inspiration from common smart-home information architecture without copying a
specific product.

## Foundations

| Token | Value | Usage |
| --- | --- | --- |
| Primary | `#26A69A` | Main actions and active controls |
| Background | `#F6F8FA` | App background |
| Surface | `#FFFFFF` | Cards and panels |
| Text | `#1D2939` | Primary content |
| Muted text | `#667085` | Secondary status |
| Border | `#EAECF0` | Surface boundaries |
| Light accent | `#FFB547` | Light-specific feedback |
| AC accent | `#4A90E2` | Air-conditioner feedback |

Spacing follows an 8 px grid with 4 px and 12 px intermediate tokens. Cards use
a 16 px radius; large control panels use 24 px. Interactive targets must be at
least 44 x 44 px.

## Components

- `MiniHomeDeviceCard`: shared device summary with type icon, status and power.
- `MiniHomeEmptyState`: empty or first-run state with one primary action.
- `AppSurfaceCard`: default white surface for cards and control panels.
- `AppSettingsListTile`: shared settings row for the My/account area.
- Status badges always combine color with text.
- Offline controls remain visible but disabled.

English is the default locale. Every new user-facing key must be added to both
`en.json` and `ja.json` in the same change.
