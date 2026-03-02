# Avoid ToDo App

A cool to-do app with a twist built with Flutter. 
List the things you need to avoid doing!
Based on this tutorial
- [Flutter ToDo App Tutorial for Beginners](https://youtu.be/K4P5DZ9TRns)

Modified Theming
Added SQL lite storage for persistence.
Added side menu
Added app icon and splash screen

## Google Play Update Steps

### One-time setup (already done in this project)

1. Keep your upload keystore at project root:
   `upload-keystore.jks`
2. Create `android/key.properties`:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=../upload-keystore.jks
```

3. Ensure release signing is enabled in `android/app/build.gradle`:
   `signingConfig = signingConfigs.release`

### For every new Play Store update

1. Bump app version in `pubspec.yaml`:
   `version: 1.0.1+2`
2. Run release build:
   `flutter build appbundle --release 2>&1`
   `flutter build appbundle --release`
3. Upload generated bundle to Play Console:
   `build/app/outputs/bundle/release/app-release.aab`
4. In Play Console:
   `App > Production (or your track) > Create new release > Upload .aab > Save > Review > Roll out`

### Versioning rule

- `build number` (the number after `+`) must always be higher than the last uploaded one.
- Example sequence: `1.0.0+1`, `1.0.1+2`, `1.0.2+3`.

## App Store Update Steps (iOS)

### For every new App Store update

1. Bump app version in `pubspec.yaml`:
   `version: 1.0.1+2`
2. Ensure Apple signing is valid in Xcode:
   `ios/Runner.xcworkspace -> Runner target -> Signing & Capabilities -> Team + Automatically manage signing`
3. Build/export IPA:
   `flutter build ipa --release 2>&1`
   `flutter build ipa --release --build-name 1.0.1 --build-number 2`
4. Upload in App Store Connect: (archive first)
   `My Apps -> Your App -> TestFlight/App Store -> Add build -> Submit for review`

### If CLI build fails with signing/profile errors

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Log in to your Apple account in:
   `Xcode -> Settings -> Accounts`.
3. In Runner signing settings, select your team and keep automatic signing enabled.
4. Build once from Xcode (`Product -> Build`) to let Xcode fetch/create provisioning profiles.
5. Archive and upload from Xcode:
   `Product -> Archive -> Distribute App -> App Store Connect -> Upload`.


## Updates and localization
`flutter pub get`
`flutter gen-l10n` (redudant now, it is integrated with the build)

## Testing
`flutter devices`
`flutter run -d `
`flutter run --release -d `

`flutter emulators`
`flutter emulators --launch `


