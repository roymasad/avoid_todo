# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get          # install dependencies
flutter run              # run on connected device/emulator
flutter run -d <id>      # target specific device
flutter test             # run all tests
flutter test test/widget_test.dart  # run a single test file
flutter build appbundle --release   # Android AAB
flutter build ipa --release --build-name 1.0.5 --build-number 6  # iOS IPA
```

After modifying any `.arb` localization file, regenerate with:
```bash
flutter gen-l10n
```

## Architecture

**App** — "Avoid Todo": track habits/things you want to avoid. Core concepts: habits (`ToDo`), relapse logs, streaks, XP/levels, goals, trusted support contacts.

**State management** — `provider` with 5 providers registered in `main.dart`:
- `PurchaseProvider` — RevenueCat Plus subscription + 10-day trial state; `isPlus` gates premium features
- `XpProvider` — XP, level, badges
- `GoalProvider` — user goals
- `ThemeProvider` / `LocaleProvider` — app-wide theme and locale

**Persistence** — `sqflite` via singleton `DatabaseHelper.instance` (`lib/helpers/database_helper.dart`). DB version 14; schema migrations in `_upgradeDB`. Tables: `todo`, `relapse_logs`, `tags`, `todo_tags`, `goals`, `trusted_support_contacts`.

**Data model** — `ToDo` (lib/model/todo.dart) is the core entity: supports priorities, tags, cost tracking, recurral, contact/location attachment. `RelapseLog` stores each relapse with trigger notes and follow-up reflections.

**Localization** — ARB-based, 6 languages (en, fr, es, it, pt, de). Source files in `lib/l10n/*.arb`; generated output also in `lib/l10n/`. Config in `l10n.yaml`. Use `AppLocalizations.of(context)!` in UI.

**Plus feature gating** — Always show Plus features to free users (never hide them). Gate with a gold "Plus" badge + greyed style; tapping calls `_showPlusDialog`. Check `context.watch<PurchaseProvider>().isPlus`.

**Home screen widgets**
- Android: `android/app/src/main/kotlin/…/AvoidWidgetProvider.kt`, data pushed via `HomeWidget` shared prefs in `lib/helpers/home_widget_helper.dart`
- iOS: `ios/AvoidWidget/AvoidWidget.swift` (WidgetKit), reads from App Group `group.com.roymassaad.avoid_todo`

**Cloud sync**
- iOS: iCloud Documents via `icloud_storage`, container `iCloud.com.roymassaad.avoidtodo`
- Android: Google Drive via `google_sign_in` + `googleapis`
- Logic in `lib/helpers/sync_helper.dart`, UI in `lib/screens/sync_screen.dart`

**Notifications** — `flutter_local_notifications` + `timezone`. Daily check-in and weekly digest scheduled at startup in `main.dart`.

**Monetization** — RevenueCat (`purchases_flutter`). Initialized via `lib/helpers/purchase_helper.dart`. Trial logic in `lib/helpers/trial_repository.dart` + `lib/model/trial_status.dart`.

**Key screens**
- `lib/screens/home.dart` — main list + settings drawer
- `lib/screens/statistics_screen.dart` — stats dashboard (Plus-gated sections use `_buildLockedSection`)
- `lib/screens/widget_setup_screen.dart` — widget colour picker + live preview
- `lib/screens/sync_screen.dart` — cloud backup UI

## Release notes

- Android release builds require `android/key.properties` + `upload-keystore.jks` (already present, not committed).
- iOS release signing is configured in Xcode (`ios/Runner.xcworkspace`).
- Bump `version` in `pubspec.yaml` before each release.
- `packages/flutter_contacts/` is a vendored local package (path dependency).
