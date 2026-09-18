import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bart_app/common/entity/settings.dart';
import 'package:bart_app/common/entity/user_local_profile.dart';

import '../../helpers/fixtures.dart';

Map<String, dynamic> _firestoreMap({
  Map<String, dynamic> overrides = const {},
}) {
  return {
    'userID': 'user-9',
    'userName': 'bob',
    'fullName': 'Bob Brown',
    'chats': ['chat-a', 'chat-b'],
    'isFirstLogin': false,
    'imageUrl': 'https://example.test/bob.png',
    'settings': {
      'isDarkMode': true,
      'isLegacyUI': false,
      'lastUpdated': kFixedTimestamp,
      'lastUpdatedString': kFixedTimestamp.toDate().toIso8601String(),
    },
    'localeString': 'fr',
    'lastUpdated': kFixedTimestamp,
    'fcmToken': 'token-9',
    ...overrides,
  };
}

void main() {
  group('UserLocalProfile.empty', () {
    test('describes a deleted user', () {
      final empty = UserLocalProfile.empty();

      expect(empty.isNull, isTrue);
      expect(empty.userID, isEmpty);
      expect(empty.userName, 'Deleted User');
      expect(empty.fullName, 'Deleted User');
      expect(empty.settings, isNull);
    });

    test('hands back one shared instance, not a fresh copy per call', () {
      // _invalidObj is a static final and userName / fullName / isNull are all
      // mutable, so anything that writes to UserLocalProfile.empty() mutates the
      // placeholder for the whole process. Pinned here so that if the factory is
      // ever changed to return a new instance, this test flags the callers that
      // were relying on the shared one.
      expect(
        identical(UserLocalProfile.empty(), UserLocalProfile.empty()),
        isTrue,
      );
    });
  });

  group('UserLocalProfile.fromMap', () {
    test('reads every field off the Firestore document', () {
      final user = UserLocalProfile.fromMap(_firestoreMap());

      expect(user.userID, 'user-9');
      expect(user.userName, 'bob');
      expect(user.fullName, 'Bob Brown');
      expect(user.chats, ['chat-a', 'chat-b']);
      expect(user.isFirstLogin, isFalse);
      expect(user.localeString, 'fr');
      expect(user.fcmToken, 'token-9');
      expect(user.settings!.isDarkMode, isTrue);
      expect(user.lastUpdated, kFixedTimestamp);
      expect(user.isNull, isFalse);
    });

    test('treats a missing chats array as empty rather than throwing', () {
      final user = UserLocalProfile.fromMap(
        _firestoreMap(overrides: {'chats': null}),
      );

      expect(user.chats, isEmpty);
    });

    test('treats a missing fcmToken as an empty string', () {
      final user = UserLocalProfile.fromMap(
        _firestoreMap(overrides: {'fcmToken': null}),
      );

      expect(user.fcmToken, '');
    });

    test('stamps lastUpdated with now when the document has none', () {
      final user = UserLocalProfile.fromMap(
        _firestoreMap(overrides: {'lastUpdated': null}),
      );

      expect(user.lastUpdated, isA<Timestamp>());
    });
  });

  group('UserLocalProfile JSON round-trip (shared_preferences)', () {
    test('survives encode then decode', () {
      final original = buildUser(
        userID: 'user-7',
        userName: 'carol',
        fullName: 'Carol Clark',
        chats: ['chat-x'],
        localeString: 'fr-CA',
        settings: buildSettings(isDarkMode: true, isLegacyUI: true),
      );

      final restored = UserLocalProfile.fromJson(original.toJson());

      expect(restored.userID, original.userID);
      expect(restored.userName, original.userName);
      expect(restored.fullName, original.fullName);
      expect(restored.chats, original.chats);
      expect(restored.isFirstLogin, original.isFirstLogin);
      expect(restored.imageUrl, original.imageUrl);
      expect(restored.localeString, original.localeString);
      expect(restored.fcmToken, original.fcmToken);
      expect(restored.settings!.isDarkMode, isTrue);
      expect(restored.settings!.isLegacyUI, isTrue);
      expect(restored.lastUpdated, original.lastUpdated);
    });

    test('toJson serialises the timestamp as an ISO-8601 string', () {
      final json = buildUser().toJson();

      expect(json['lastUpdated'], isA<String>());
      expect(
        () => DateTime.parse(json['lastUpdated'] as String),
        returnsNormally,
      );
    });

    test('fromJson defaults a missing locale to English', () {
      final json = buildUser().toJson();
      json['localeString'] = null;

      expect(UserLocalProfile.fromJson(json).localeString, 'en');
    });
  });

  group('UserLocalProfile.localeFromString', () {
    final user = buildUser();

    test('parses a bare language tag', () {
      final locale = user.localeFromString('fr');

      expect(locale.languageCode, 'fr');
      expect(locale.countryCode, isNull);
    });

    test('parses a language-country tag', () {
      final locale = user.localeFromString('fr-CA');

      expect(locale.languageCode, 'fr');
      expect(locale.countryCode, 'CA');
    });

    test('returns a Locale usable by MaterialApp', () {
      expect(user.localeFromString('en-GB'), isA<Locale>());
    });
  });

  group('UserLocalProfile.updateLocaleString', () {
    test('normalises a bare language tag', () {
      final user = buildUser(localeString: 'en');

      user.updateLocaleString('fr');

      expect(user.localeString, 'fr');
    });

    test('normalises a language-country tag back into dash form', () {
      final user = buildUser(localeString: 'en');

      user.updateLocaleString('fr-CA');

      expect(user.localeString, 'fr-CA');
    });

    test('refreshes lastUpdated', () {
      final user = buildUser(lastUpdated: kFixedTimestamp);

      user.updateLocaleString('fr');

      expect(user.lastUpdated, isNot(kFixedTimestamp));
    });
  });

  group('UserLocalProfile.mergeCurrentSettings', () {
    test('takes identity from the new profile but UI prefs from the old', () {
      final old = buildUser(
        userName: 'old-name',
        settings: buildSettings(isDarkMode: true, isLegacyUI: true),
      );
      final incoming = buildUser(
        userName: 'new-name',
        fullName: 'New Name',
        chats: ['chat-new'],
        settings: buildSettings(
          isDarkMode: false,
          isLegacyUI: false,
          lastUpdated: kNextDayTimestamp,
        ),
      );

      final merged = UserLocalProfile.mergeCurrentSettings(old, incoming);

      expect(merged.userName, 'new-name');
      expect(merged.fullName, 'New Name');
      expect(merged.chats, ['chat-new']);
      expect(merged.settings!.isDarkMode, isTrue, reason: 'kept from old');
      expect(merged.settings!.isLegacyUI, isTrue, reason: 'kept from old');
    });

    test('defaults a null fcmToken on the new profile to an empty string', () {
      final merged = UserLocalProfile.mergeCurrentSettings(
        buildUser(),
        buildUser(fcmToken: null),
      );

      expect(merged.fcmToken, '');
    });

    test('throws when either side is missing settings', () {
      // mergeCurrentSettings force-unwraps both settings fields, so a profile
      // has to be fully hydrated before it can be merged.
      final noSettings = UserLocalProfile(userID: 'x', settings: null);

      expect(
        () => UserLocalProfile.mergeCurrentSettings(noSettings, buildUser()),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('UserLocalProfile.toString', () {
    test('renders the JSON payload for debugging', () {
      final text = buildUser(userName: 'dana').toString();

      expect(text, startsWith('UserLocalProfile: '));
      expect(text, contains('dana'));
    });
  });

  group('UserSettings interop', () {
    test('a profile carries usable settings through construction', () {
      final user = buildUser(settings: UserSettings(isDarkMode: true));

      expect(user.settings, isA<UserSettings>());
      expect(user.settings!.isDarkMode, isTrue);
    });
  });
}
