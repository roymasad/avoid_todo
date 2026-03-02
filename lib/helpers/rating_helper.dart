import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Configuration constants for the rating feature.
///
/// Before a production build:
///   1. Set [debugForceShow] back to `false`.
///   2. Fill in [formActionUrl] and [formEntryId] from your Google Form.
///   3. Fill in [appStoreUrl] with your numeric App Store ID.
abstract final class RatingConfig {
  /// Set to `true` during development to force the rating dialog on every
  /// app launch, regardless of the normal 25–30 day interval.
  /// IMPORTANT: Set back to `false` before any production build.
  static const bool debugForceShow = false;

  /// Google Form endpoint. Get this from the form's HTML action attribute.
  /// Example: 'https://docs.google.com/forms/d/e/1FAIpQLSe.../formResponse'
  static const String formActionUrl =
      'https://docs.google.com/forms/d/e/1FAIpQLSd_udjvjnYXSnqMALnsn7jIk2BmjMti9-aKaQE7buKgxNNiVg/formResponse';

  /// The entry field ID for the feedback textarea in your Google Form.
  /// Example: 'entry.1234567890'
  static const String formEntryId = 'entry.1800117815';

  /// iOS App Store URL. Get your numeric app ID from App Store Connect.
  static const String appStoreUrl =
      'https://apps.apple.com/us/app/avoid-todo/id6739147229';

  /// Android Play Store deep link (opens the Play Store app directly).
  static const String playStoreUrl =
      'market://details?id=com.roymassaad.avoid_todo';

  /// Fallback web URL for Android if the market:// scheme is not available.
  static const String playStoreUrlFallback =
      'https://play.google.com/store/apps/details?id=com.roymassaad.avoid_todo';
}

class RatingHelper {
  static const String _kFirstLaunch = 'rating_first_launch_ms';
  static const String _kNextShow = 'rating_next_show_ms';
  static const String _kCompleted = 'rating_completed';

  static int _randomDays() => Random().nextInt(6) + 25; // 25–30 (for repeats)
  static int _randomFirstDays() => Random().nextInt(3) + 3; // 3–5 (first ask)

  /// Returns `true` if the rating dialog should be shown on this launch.
  static Future<bool> shouldShowRatingDialog() async {
    if (RatingConfig.debugForceShow) return true;

    final prefs = await SharedPreferences.getInstance();

    // Never show again once the user has tapped "Rate Now".
    if (prefs.getBool(_kCompleted) == true) return false;

    final now = DateTime.now();
    final nextShowMs = prefs.getInt(_kNextShow);

    if (nextShowMs == null) {
      // First ever launch: record the install date and schedule the first show.
      if (prefs.getInt(_kFirstLaunch) == null) {
        await prefs.setInt(_kFirstLaunch, now.millisecondsSinceEpoch);
      }
      final firstShow = now.add(Duration(days: _randomFirstDays()));
      await prefs.setInt(_kNextShow, firstShow.millisecondsSinceEpoch);
      return false;
    }

    return now.isAfter(DateTime.fromMillisecondsSinceEpoch(nextShowMs));
  }

  /// Call after the dialog is dismissed (any path except "Rate Now").
  /// Schedules the next prompt 25–30 days from now.
  static Future<void> recordDialogShown() async {
    final prefs = await SharedPreferences.getInstance();
    final next = DateTime.now().add(Duration(days: _randomDays()));
    await prefs.setInt(_kNextShow, next.millisecondsSinceEpoch);
  }

  /// Call when the user taps "Rate Now". Permanently suppresses future prompts.
  static Future<void> recordHighRating() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kCompleted, true);
  }

  /// POSTs feedback text to the configured Google Form endpoint.
  /// Fails silently so the app is never disrupted by network issues.
  static Future<void> submitFeedback(String text) async {
    try {
      await http.post(
        Uri.parse(RatingConfig.formActionUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {RatingConfig.formEntryId: text},
      );
      // Google Forms always returns a 303 redirect — intentionally ignored.
    } catch (_) {
      // Fail silently.
    }
  }

  /// Opens the platform-appropriate app store listing.
  static Future<void> openStoreListing() async {
    if (Platform.isIOS) {
      final uri = Uri.parse(RatingConfig.appStoreUrl);
      if (await canLaunchUrl(uri)) await launchUrl(uri);
    } else {
      final marketUri = Uri.parse(RatingConfig.playStoreUrl);
      if (await canLaunchUrl(marketUri)) {
        await launchUrl(marketUri);
      } else {
        final webUri = Uri.parse(RatingConfig.playStoreUrlFallback);
        if (await canLaunchUrl(webUri)) await launchUrl(webUri);
      }
    }
  }
}
