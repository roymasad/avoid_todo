# Repository Guidelines

## Project Structure & Module Organization
`lib/` contains the Flutter app: `screens/` for user flows, `providers/` for `provider` state, `helpers/` for storage/notifications/sync, `model/` for domain objects, `constants/` for theme data, and `l10n/` for localization sources and generated files. Tests live in `test/` and mirror app areas such as `test/helpers/` and `test/providers/`. Static assets are under `assets/images/`. Native platform code is in `android/` and `ios/`. The repo also vendors a local plugin in `packages/flutter_contacts/`; treat it as a separate package when changing contact behavior.

## Build, Test, and Development Commands
Run `flutter pub get` after dependency changes. Use `flutter run` for local development, or `flutter run -d <device_id>` for a specific simulator/device. Run `flutter analyze` before opening a PR to catch lint and type issues. Format with `dart format lib test packages/flutter_contacts/lib packages/flutter_contacts/test`. Run app tests with `flutter test`, and run package tests from `packages/flutter_contacts/` with `flutter test`. Release builds use `flutter build appbundle --release` for Android and `flutter build ipa --release --build-name <x.y.z> --build-number <n>` for iOS.

## Coding Style & Naming Conventions
Follow standard Dart style: 2-space indentation, trailing commas where they improve formatting, `UpperCamelCase` for types, `lowerCamelCase` for members, and `snake_case.dart` filenames. Keep widgets and providers focused; move persistence, sync, and notification logic into `helpers/`. Do not hand-edit generated files in `lib/l10n/app_localizations*.dart`; update the `.arb` files instead. Linting is defined by `flutter_lints` in `analysis_options.yaml`.

## Testing Guidelines
Use `flutter_test` for widget and unit coverage. Name tests with the `_test.dart` suffix and group them near the feature they validate, for example `test/providers/purchase_provider_test.dart`. Add or update tests for provider logic, helper behavior, and any UI flow with conditional rendering. When changing `packages/flutter_contacts/`, run that package’s tests in addition to the root suite.

## Commit & Pull Request Guidelines
Recent history uses short, typed commit prefixes such as `feat:`, `bugfix:`, and `refactor:`. Keep commits scoped and written in the imperative. PRs should summarize user-visible changes, note any platform-specific setup changes (`android/key.properties`, iOS signing, RevenueCat, Google Sign-In, iCloud), and include screenshots or recordings for UI updates. Link related issues and list the commands you ran to validate the change.
