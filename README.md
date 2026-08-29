# Industrial Asset Management Mobile

A Flutter companion app for field inspections and industrial equipment
operations. It supports responsive phone, tablet, and desktop layouts while
keeping frequently used records available offline.

## Capabilities

- Equipment inventory and detailed asset views.
- Guided digital inspections with signatures and photos.
- Dispatch and return movement tracking.
- Offline caching with Hive and background synchronization.
- Realtime updates through Socket.IO.
- Responsive interfaces for field and office workflows.
- Authentication with cached-session recovery.

## Architecture

```text
Flutter UI -> Provider state -> repositories -> REST services
                              -> Hive offline cache
                              -> Socket.IO updates
```

## Requirements

- Flutter 2.10 or a compatible Dart 2 SDK
- The `industrial-asset-management-api` service

## Run

Install dependencies and provide the API URL at build time:

```bash
flutter pub get
flutter run --dart-define=API_URL=http://10.0.2.2:3000
```

Use `localhost` instead of `10.0.2.2` when running the desktop target.

## Validate

```bash
flutter analyze
flutter test
```

The repository excludes production credentials, customer data, and
environment-specific editor settings.
