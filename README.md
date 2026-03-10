# Avoid Todo

![Avoid Todo logo](assets/images/avoid_logo.png)

Avoid Todo is a Flutter app for tracking things you are trying not to do.
Instead of a classic to-do list, it focuses on avoidance habits: streaks,
relapses, triggers, money/time cost, reminders, and reflection.

## What ships today

- Track multiple "things to avoid" with streaks, relapse counts, priorities,
  tags, notes, and cost tracking.
- Log relapses with trigger notes and follow-up reflections.
- Attach a habit to a person or place to make the reminder more contextual.
- Daily check-in notifications, weekly digest notifications, and relapse
  follow-up prompts.
- Statistics dashboard with streaks, relapse trends, savings, and export.
- Archive flow for completed habits and past relapse reflections.
- XP, levels, badges, goals, and a daily commitment flow.
- Plus upgrade flow via RevenueCat.
- Home screen widget support.
- Cloud backup/sync using iCloud on iOS and Google Drive on Android.
- Trusted support flow for preparing outreach after a relapse.
- Localization in English, French, Spanish, Italian, Portuguese, and German.

## Stack

- Flutter / Dart
- `provider` for state management
- `sqflite` for local persistence
- `flutter_local_notifications` for reminders
- `purchases_flutter` / `purchases_ui_flutter` for monetization
- `home_widget` for widgets
- `google_sign_in` + Google Drive API for Android backup
- `icloud_storage` for iOS backup

## Project layout

- `lib/main.dart`: app bootstrap, providers, onboarding gate, startup services
- `lib/screens/`: main UI flows such as home, statistics, sync, onboarding
- `lib/helpers/`: storage, notifications, purchases, sync, export, widgets
- `lib/providers/`: app state for theme, locale, purchases, XP, goals
- `lib/model/`: core data models
- `lib/l10n/`: generated and source localization files
- `test/`: widget and unit tests
- `packages/flutter_contacts/`: vendored local package used by the app

## Getting started

### Prerequisites

- Flutter SDK compatible with Dart `^3.5.3`
- Xcode for iOS development
- Android Studio / Android SDK for Android development

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

Useful variants:

```bash
flutter devices
flutter emulators
flutter run -d <device_id>
flutter run --release -d <device_id>
```

## Configuration notes

### Android

- Firebase Android config is already present in
  `android/app/google-services.json`.
- Release builds expect `android/key.properties` plus an upload keystore.

Example `android/key.properties`:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=../upload-keystore.jks
```

### iOS

- The app includes iCloud entitlements and a widget extension.
- Release signing still needs to be valid in Xcode for your Apple team.
- If you change bundle identifiers, update the App Group / iCloud identifiers
  as well.

### Service integrations

- RevenueCat is initialized in `lib/helpers/purchase_helper.dart`.
- Android cloud backup uses Google Sign-In + Drive API.
- iOS cloud backup uses iCloud documents storage.
- Some features depend on native permissions such as contacts, notifications,
  and location.

## Testing

```bash
flutter test
```

## Build and release

### Android App Bundle

1. Bump the version in `pubspec.yaml`.
2. Ensure `android/key.properties` and the upload keystore are present.
3. Build:

```bash
flutter build appbundle --release
```

Output:

`build/app/outputs/bundle/release/app-release.aab`

### iOS IPA

1. Bump the version in `pubspec.yaml`.
2. Confirm signing in `ios/Runner.xcworkspace`.
3. Build:

`
cd ios
pod install --repo-update (delete .lock if it gives you trouble)
`

```bash
flutter build ipa --release --build-name 1.0.5 --build-number 6
```

If CLI signing fails, archive and upload from Xcode instead.

## Notes

- `MONETIZATION.md` contains pricing and roadmap thinking. It is not the source
  of truth for what is already shipped; the list above is based on the current
  codebase.
- This repository is a private app project and is not intended for `pub.dev`
  publication.
