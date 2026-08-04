# Security and public repository policy

🌐 English | [日本語](security.ja.md)

miniHome is intended to be published as a public portfolio repository. The Git
history must not contain credentials, signing assets, real user data, or private
project identifiers.

## Do not commit

- Local runtime config files.
- `.env` files and derived environment files.
- Firebase native config files.
- Android signing keys and key properties.
- Apple distribution `ExportOptions` files.
- Real access tokens, refresh tokens, passwords, or API secrets.
- Real user emails, phone numbers, addresses, or device identifiers.

The root `.gitignore` is the source of truth for ignored files.

## Runtime configuration

Publicly safe configuration keys are documented in
`config/app_config.example.json`.

Local values must be stored in:

```text
config/app_config.local.json
```

Run the app with:

```sh
fvm flutter run \
  --flavor homeStaging \
  --dart-define-from-file=config/app_config.local.json
```

When using Mockoon only, keep the local API key empty and disable Firebase in the
local config. The app should not require private Firebase values for the demo
Mockoon flow.

## Firebase

Firebase client configuration is not a security boundary by itself.

Before connecting a real Firebase project:

- Use a miniHome-specific Firebase project.
- Configure Firestore Security Rules before storing any data.
- Restrict Authentication authorized domains.
- Enable App Check when the project is ready for it.
- Never store service-account private keys in the app or repository.

## Mockoon data

`mockoon.json` must contain fictional data only.

- Use obviously fake tokens.
- Do not use real email addresses.
- Do not use production device IDs.
- Do not copy production API responses directly.

## Pre-commit checklist

```sh
git status --short --untracked-files=all
git diff --cached
rg -n -i 'api[_-]?key|client[_-]?secret|private[_-]?key|access[_-]?token|refresh[_-]?token|password'
```

If a secret is committed by mistake, deleting the file in a later commit is not
enough. Remove the secret from Git history before publishing the repository, and
rotate or revoke the exposed key/token.
