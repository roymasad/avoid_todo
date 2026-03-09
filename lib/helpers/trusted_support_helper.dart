import 'dart:io';

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/trusted_support_contact.dart';

enum TrustedSupportComposeResult { opened, sent, cancelled, unavailable, error }

class TrustedSupportTemplate {
  final String label;
  final String body;

  const TrustedSupportTemplate({
    required this.label,
    required this.body,
  });
}

class TrustedSupportHelper {
  TrustedSupportHelper._();

  static const MethodChannel _channel =
      MethodChannel('avoid_todo/trusted_support');
  static const String _sharedFooter = 'Shared from Avoid app.';

  static List<TrustedSupportTemplate> buildTemplates(String supporterName) {
    final firstName = _firstName(supporterName);
    return [
      TrustedSupportTemplate(
        label: 'Gentle',
        body:
            'Hey $firstName, I had a tough moment and could use some support today.\n\n$_sharedFooter',
      ),
      TrustedSupportTemplate(
        label: 'Direct',
        body:
            'Hey $firstName, I slipped up and I do not want to spiral. Could you check in on me when you can?\n\n$_sharedFooter',
      ),
      TrustedSupportTemplate(
        label: 'Short',
        body:
            'Hey $firstName, hard moment right now. If you are free, please message or call me.\n\n$_sharedFooter',
      ),
    ];
  }

  static String defaultEmailSubject(String supporterName) {
    final firstName = _firstName(supporterName);
    return 'Could use your support today, $firstName';
  }

  static String maskDestination(
    TrustedSupportChannel channel,
    String destination,
  ) {
    if (destination.isEmpty) return '';
    if (channel == TrustedSupportChannel.email) {
      final parts = destination.split('@');
      if (parts.length != 2 || parts.first.isEmpty) return destination;
      final local = parts.first;
      final domain = parts.last;
      final visible = local[0];
      return '$visible•••@$domain';
    }

    final digits = destination.replaceAll(RegExp(r'\s+'), '');
    if (digits.length <= 2) return digits;
    return '•••${digits.substring(digits.length - 2)}';
  }

  static Future<TrustedSupportComposeResult> composeTrustedSupportMessage({
    required TrustedSupportContact contact,
    required String body,
  }) async {
    try {
      switch (contact.channel) {
        case TrustedSupportChannel.email:
          return await _composeEmail(
            contact.destinationValue,
            defaultEmailSubject(contact.contactName),
            body,
          );
        case TrustedSupportChannel.sms:
          if (Platform.isIOS) {
            return await _composeSmsIos(contact.destinationValue, body);
          }
          return await _composeSms(contact.destinationValue, body);
      }
    } catch (_) {
      return TrustedSupportComposeResult.error;
    }
  }

  static Future<TrustedSupportComposeResult> _composeEmail(
    String recipient,
    String subject,
    String body,
  ) async {
    final uri = Uri(
      scheme: 'mailto',
      path: recipient,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );
    return _launchUri(uri);
  }

  static Future<TrustedSupportComposeResult> _composeSms(
    String recipient,
    String body,
  ) async {
    final uri = Uri(
      scheme: 'sms',
      path: recipient,
      queryParameters: {'body': body},
    );
    return _launchUri(uri);
  }

  static Future<TrustedSupportComposeResult> _composeSmsIos(
    String recipient,
    String body,
  ) async {
    final raw = await _channel.invokeMethod<String>('composeSms', {
      'recipient': recipient,
      'body': body,
    });
    return _resultFromString(raw);
  }

  static Future<TrustedSupportComposeResult> _launchUri(Uri uri) async {
    if (!await canLaunchUrl(uri)) {
      return TrustedSupportComposeResult.unavailable;
    }
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    return opened
        ? TrustedSupportComposeResult.opened
        : TrustedSupportComposeResult.error;
  }

  static TrustedSupportComposeResult _resultFromString(String? value) {
    switch (value) {
      case 'opened':
        return TrustedSupportComposeResult.opened;
      case 'sent':
        return TrustedSupportComposeResult.sent;
      case 'cancelled':
        return TrustedSupportComposeResult.cancelled;
      case 'unavailable':
        return TrustedSupportComposeResult.unavailable;
      default:
        return TrustedSupportComposeResult.error;
    }
  }

  static String _firstName(String fullName) {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) return 'there';
    return trimmed.split(RegExp(r'\s+')).first;
  }
}
