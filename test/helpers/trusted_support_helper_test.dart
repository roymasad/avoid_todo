import 'package:avoid_todo/helpers/trusted_support_helper.dart';
import 'package:avoid_todo/model/trusted_support_contact.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TrustedSupportHelper', () {
    test('buildTemplates personalizes with first name', () {
      final templates = TrustedSupportHelper.buildTemplates('Sarah Connor');

      expect(templates, hasLength(3));
      expect(templates.first.body, contains('Sarah'));
      expect(templates.first.body, isNot(contains('Connor')));
    });

    test('maskDestination masks phone and email values', () {
      expect(
        TrustedSupportHelper.maskDestination(
          TrustedSupportChannel.sms,
          '+15551234',
        ),
        '•••34',
      );
      expect(
        TrustedSupportHelper.maskDestination(
          TrustedSupportChannel.email,
          'sarah@example.com',
        ),
        's•••@example.com',
      );
    });
  });

  group('TrustedSupportContact', () {
    test('round-trips from map', () {
      final contact = TrustedSupportContact(
        id: 1,
        contactId: 'abc',
        contactName: 'Sarah',
        channel: TrustedSupportChannel.email,
        destinationValue: 'sarah@example.com',
        destinationLabel: 'home',
        isEnabled: true,
        createdAt: DateTime.parse('2026-03-09T10:00:00.000'),
        updatedAt: DateTime.parse('2026-03-09T10:05:00.000'),
      );

      final decoded = TrustedSupportContact.fromMap(contact.toMap());

      expect(decoded.id, 1);
      expect(decoded.contactId, 'abc');
      expect(decoded.channel, TrustedSupportChannel.email);
      expect(decoded.destinationValue, 'sarah@example.com');
      expect(decoded.isEnabled, isTrue);
    });
  });
}
