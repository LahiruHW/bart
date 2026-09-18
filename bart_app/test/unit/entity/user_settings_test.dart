import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bart_app/common/entity/settings.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('UserSettings construction', () {
    test('defaults to light mode, modern UI and no timestamps', () {
      final settings = UserSettings();

      expect(settings.isDarkMode, isFalse);
      expect(settings.isLegacyUI, isFalse);
      expect(settings.lastUpdated, isNull);
      expect(settings.lastUpdatedString, isNull);
    });
  });

  group('UserSettings.updateSettings', () {
    test('applies the supplied flags', () {
      final settings = buildSettings(isDarkMode: false, isLegacyUI: false);

      settings.updateSettings(isDarkMode: true, isLegacyUI: true);

      expect(settings.isDarkMode, isTrue);
      expect(settings.isLegacyUI, isTrue);
    });

    test('leaves unsupplied flags untouched', () {
      final settings = buildSettings(isDarkMode: true, isLegacyUI: true);

      settings.updateSettings(isDarkMode: false);

      expect(settings.isDarkMode, isFalse);
      expect(settings.isLegacyUI, isTrue, reason: 'not passed, so unchanged');
    });

    test(
      'always stamps the current time, ignoring the passed-in timestamps',
      () {
        final settings = buildSettings();
        final before = Timestamp.now();

        // The method signature accepts lastUpdated/lastUpdatedString but
        // deliberately overwrites both with "now" — asserted here so a future
        // change to that behaviour is caught rather than silently shipped.
        settings.updateSettings(
          isDarkMode: true,
          lastUpdated: DateTime.utc(1999),
          lastUpdatedString: 'ignored',
        );

        expect(settings.lastUpdatedString, isNot('ignored'));
        expect(
          settings.lastUpdated!.compareTo(before),
          greaterThanOrEqualTo(0),
        );
        expect(
          settings.lastUpdatedString,
          settings.lastUpdated!.toDate().toIso8601String(),
        );
      },
    );
  });

  group('UserSettings.fromMap', () {
    test('reads the Firestore shape', () {
      final stamp = kFixedTimestamp;

      final settings = UserSettings.fromMap({
        'isDarkMode': true,
        'isLegacyUI': true,
        'lastUpdated': stamp,
        'lastUpdatedString': stamp.toDate().toIso8601String(),
      });

      expect(settings.isDarkMode, isTrue);
      expect(settings.isLegacyUI, isTrue);
      expect(settings.lastUpdated, stamp);
    });
  });

  group('UserSettings.toMap', () {
    test('emits a Firestore Timestamp, not a string', () {
      final map = buildSettings(isDarkMode: true).toMap();

      expect(map['isDarkMode'], isTrue);
      expect(map['isLegacyUI'], isFalse);
      expect(map['lastUpdated'], isA<Timestamp>());
      expect(
        map.containsKey('lastUpdatedString'),
        isFalse,
        reason: 'lastUpdatedString is debug-only and is not persisted',
      );
    });

    test('substitutes the current time when lastUpdated is null', () {
      final map = UserSettings().toMap();

      expect(map['lastUpdated'], isA<Timestamp>());
    });
  });

  group('UserSettings JSON round-trip (shared_preferences)', () {
    test('survives encode then decode', () {
      final original = buildSettings(isDarkMode: true, isLegacyUI: true);

      final restored = UserSettings.fromJson(original.toJson());

      expect(restored.isDarkMode, original.isDarkMode);
      expect(restored.isLegacyUI, original.isLegacyUI);
      expect(restored.lastUpdatedString, original.lastUpdatedString);
      expect(restored.lastUpdated, original.lastUpdated);
    });

    test(
      'encodes timestamps as ISO-8601 strings, since JSON has no Timestamp',
      () {
        final json = buildSettings().toJson();

        expect(json['lastUpdated'], isA<String>());
        expect(json['lastUpdatedString'], isA<String>());
        expect(
          () => DateTime.parse(json['lastUpdated'] as String),
          returnsNormally,
        );
      },
    );

    test(
      'falls back to now when the object has no stored timestamp string',
      () {
        final json = UserSettings(isDarkMode: true).toJson();

        expect(json['lastUpdated'], isA<String>());
        expect(json['lastUpdated'], json['lastUpdatedString']);
      },
    );
  });

  group('UserSettings.mergeWithExisting', () {
    test('keeps the old UI preferences and takes the new timestamps', () {
      final old = buildSettings(
        isDarkMode: true,
        isLegacyUI: true,
        lastUpdated: kFixedTimestamp,
      );
      final incoming = buildSettings(
        isDarkMode: false,
        isLegacyUI: false,
        lastUpdated: kNextDayTimestamp,
      );

      final merged = UserSettings.mergeWithExisting(old, incoming);

      // The local device is treated as the source of truth for the look of the
      // app; only the freshness markers come from the remote copy.
      expect(merged.isDarkMode, isTrue);
      expect(merged.isLegacyUI, isTrue);
      expect(merged.lastUpdated, kNextDayTimestamp);
    });

    test('falls back to the old timestamp when the new one is null', () {
      final old = buildSettings(lastUpdated: kFixedTimestamp);
      final incoming = UserSettings(isDarkMode: true);

      final merged = UserSettings.mergeWithExisting(old, incoming);

      expect(merged.lastUpdated, kFixedTimestamp);
      expect(merged.lastUpdatedString, old.lastUpdatedString);
    });

    test('falls back to now when neither side has a timestamp', () {
      final merged = UserSettings.mergeWithExisting(
        UserSettings(),
        UserSettings(),
      );

      expect(merged.lastUpdated, isNotNull);
      expect(merged.lastUpdatedString, isNotNull);
    });
  });

  group('UserSettings.toString', () {
    test('includes every flag, so debugPrint output stays useful', () {
      final text = buildSettings(isDarkMode: true, isLegacyUI: true).toString();

      expect(text, contains('isDarkMode: true'));
      expect(text, contains('isLegacyUI: true'));
      expect(text, contains('lastUpdated'));
    });
  });
}
