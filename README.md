# Retail SMB App

Flutter mobile app for Retail SMB onboarding, stock capture, operational document extraction, and dashboard insights.

## Prerequisites

1. Install Flutter SDK (stable channel).
2. Install Android Studio (or VS Code + Flutter/Dart extensions).
3. Set up Android SDK and at least one emulator/device.
4. Run:

```bash
flutter doctor
```

Make sure there are no blocking issues.

## Open and Run the App

1. Clone this repository and open it:

```bash
git clone <your-repo-url>
cd retail_smb
```

2. Install dependencies:

```bash
flutter pub get
```

3. Check available devices:

```bash
flutter devices
```

4. Run the app:

```bash
flutter run
```

Or run on a specific device:

```bash
flutter run -d <device_id>
```

## Hot Reload

While `flutter run` is active in terminal:

- Press `r` for hot reload.
- Press `R` for hot restart.

In Android Studio / VS Code, use the Hot Reload button.

## API Notes

- Base URL used by app services: `https://hackvidia.asoatram.dev`
- Auth endpoints used:
  - `POST /auth/login`
  - `POST /auth/register`

## Main User Flow

1. Register / login.
2. First-time onboarding:
   - Upload stock photo (camera flow).
   - Upload operational documents (price list, sales record, operational expenditures, capital expenditures).
3. Review summary.
4. Continue to Home and Insights.

## Build APK (Optional)

```bash
flutter build apk --release
```

Output:
`build/app/outputs/flutter-apk/app-release.apk`

## Troubleshooting

- If dependencies fail:

```bash
flutter clean
flutter pub get
```

- If device not detected:
  - Reconnect USB / restart emulator.
  - Run `flutter doctor` and fix Android toolchain issues.

- If app seems stale after big changes:
  - Use hot restart (`R`) or stop and rerun `flutter run`.
