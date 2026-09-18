# Tests

```bash
flutter test                      # everything
flutter test test/unit            # pure Dart logic only (fast)
flutter test test/widget          # widget tests
flutter test --coverage           # writes coverage/lcov.info
```

On-device tests live separately, in [`../integration_test/`](../integration_test).

## A clean checkout does not compile yet

Two things the repo needs are gitignored, so `flutter test` fails on a fresh
clone until you recreate them. CI does the same thing — see the
`Write a placeholder .env` and `Create the placeholder asset directory` steps in
[`.github/workflows/flutter-tests.yml`](../../.github/workflows/flutter-tests.yml).

1. **`.env` and the generated `bart_env.g.dart`.**
   [`bart_env.dart`](../lib/common/constants/env/bart_env.dart) declares
   `part 'bart_env.g.dart'`, which `envied` generates from `.env`. Create a
   `.env` at the project root with these keys, then generate:

   ```
   sampleAPIKey=
   internalTestLink1=
   internalTestLink2=
   fcmWebPushPrivate=
   fcmVapidKey=
   mailerUser=
   mailerPassword=
   ```

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

   Placeholder values are fine for tests — nothing in the suite sends mail or
   opens those links.

2. **`assets/secrets/`.** It is declared as an asset directory in
   `pubspec.yaml` but ignored by git. `flutter test` builds the asset bundle,
   so the directory must exist:

   ```bash
   mkdir -p assets/secrets
   ```

## Layout

| Path | What lives there |
| --- | --- |
| `test/helpers/fixtures.dart` | Builders for `Item`, `Trade`, `Message`, `UserLocalProfile`, `UserSettings`, plus fixed timestamps |
| `test/helpers/test_harness.dart` | `pumpBartWidget` and `themeExtensionOf` |
| `test/unit/` | Pure Dart: entities, extensions, enums |
| `test/widget/` | Widgets rendered through the real Bart theme |

## Writing a widget test

Almost every Bart widget reads a `ThemeExtension` via
`Theme.of(context).extension<...>()!` and sizes itself with `.w` / `.h` /
`.spMin` from `flutter_screenutil`. Both will throw if you pump the widget bare,
so go through the harness:

```dart
await pumpBartWidget(tester, const MyWidget());
expect(find.text('...'), findsOneWidget);
```

Two things to know:

- **`BartAppTheme.lightTheme` is a lazily-initialised static that itself calls
  `.spMin`.** It must not be touched before ScreenUtil is initialised, which is
  why the harness only references the themes from inside the `ScreenUtilInit`
  builder. Pumping `MaterialApp(theme: BartAppTheme.lightTheme, ...)` directly
  will throw.
- **Pass `settle: false` for anything that animates forever** — `Shimmer`,
  looping `flutter_animate` effects. `pumpAndSettle` never returns for those and
  you get a timeout instead of a useful failure.

Assert against the themed value rather than a hardcoded colour, so the test does
not break the moment the palette is edited:

```dart
final style = themeExtensionOf<BartMaterialButtonStyle>(tester);
expect(button.color, style.backgroundColor);
```

## Some tests pin current behaviour, not ideal behaviour

A few tests document quirks rather than endorse them, each with a comment
saying so. They are there to make a future change to that behaviour deliberate
and visible rather than silent:

- `Item.empty()`, `Trade.empty()` and `UserLocalProfile.empty()` each return a
  **shared static instance** with mutable fields, so writing to one mutates the
  placeholder process-wide.
- `TradeTypeChecker.isCompletedTrade(userID)` **ignores its `userID`**, so a
  user in neither side of a trade still gets `tradeHistory` back from
  `getTradeCompType`. Callers have to gate on `isUserInTrade` themselves.
- `Item.fromMap` throws on a missing `preferredInReturn`, while
  `UserLocalProfile.fromMap` tolerates a missing `chats`.
- `Message.toMap` casts `extra['itemContent']` unconditionally once
  `isSharedItem` is set, so the flag and the payload must always be written
  together.

## Not covered here

`UserLocalProfile.toMap()` uses `FieldValue.arrayUnion`, and the classes under
`lib/common/utility/` talk to Firebase, `SharedPreferences` and platform
channels. Testing those needs either fakes or the Firebase Emulator Suite, and
neither is set up yet.
