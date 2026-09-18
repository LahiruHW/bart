# Integration tests

These run on a **real device or emulator**, against the real Flutter engine.
That is what separates them from the widget tests in [`../test/`](../test): real
fonts, real text shaping, real rasterisation, real gesture timing, real plugins.

## Running them

Boot a device first (`flutter devices` to check), then:

```bash
flutter test integration_test/app_test.dart
```

To target one device when several are attached:

```bash
flutter test integration_test/app_test.dart -d <device-id>
```

## The full-boot test

`app_test.dart` contains one test that calls the app's real `main()`. It is
**skipped by default**, because `main()` contacts live Firebase — auth,
Firestore, remote config, messaging — and logs analytics events against the
production project.

Opt in explicitly:

```bash
flutter test integration_test/app_test.dart --dart-define=BART_FULL_BOOT=true
```

Point it at the Firebase Emulator Suite first if you would rather not touch
production: flip `FirebaseEmulatorService.useEmulators` to `true` in
[`lib/common/constants/use_emulators.dart`](../lib/common/constants/use_emulators.dart),
then `firebase emulators:start`.

## What CI does

CI does **not** run these — it has no device and no Firebase credentials.
Instead the `integration-build` job in
[`.github/workflows/flutter-tests.yml`](../../.github/workflows/flutter-tests.yml)
builds a debug APK with this file as the entrypoint, which compiles every
integration test against the real app code. A test that no longer compiles
fails CI; a test that would fail at runtime does not.

If you want CI to actually execute them, add an emulator job using
[`reactivecircus/android-emulator-runner`](https://github.com/ReactiveCircus/android-emulator-runner)
and give it Firebase access. Expect roughly 15–25 minutes per run.

## Prerequisites on a clean checkout

`.env` and `assets/secrets/` are gitignored, so a fresh clone does not compile
until you recreate them. See [`../test/README.md`](../test/README.md#a-clean-checkout-does-not-compile-yet).
