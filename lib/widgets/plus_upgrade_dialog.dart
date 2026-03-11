import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../helpers/app_analytics.dart';
import '../l10n/app_localizations.dart';
import '../model/trial_status.dart';
import '../providers/purchase_provider.dart';
import 'tracked_screen.dart';

Future<void> showPlusUpgradeDialog(
  BuildContext context, {
  String? subtitle,
  String entryPoint = 'unknown',
}) {
  final purchase = context.read<PurchaseProvider>();
  final messenger = ScaffoldMessenger.of(context);
  final trialStatus = purchase.trialStatus;
  final dateFormat = DateFormat.yMMMd();
  final l10n = AppLocalizations.of(context);

  AppAnalytics.instance.trackEvent(
    'plus_dialog_opened',
    parameters: {
      'source_screen': 'plus_upgrade_dialog',
      'entry_point': entryPoint,
      'has_plus': purchase.hasPurchasedPlus,
      'has_trial': purchase.hasActiveTrial,
    },
  );

  String? trialBannerText() {
    if (purchase.hasActiveTrial && trialStatus != null) {
      return 'Free trial active until ${dateFormat.format(trialStatus.expiresAtUtc.toLocal())}. '
          'Cloud backup unlocks after purchase.';
    }
    if (trialStatus != null) {
      return 'This account already used its free trial. Purchase Plus to unlock cloud backup and keep access.';
    }
    return null;
  }

  return showDialog<void>(
    context: context,
    builder: (ctx) => TrackedScreen(
      screenName: 'plus_upgrade_dialog',
      child: AlertDialog(
        scrollable: true,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        title: const Row(
          children: [
            Icon(Icons.star, color: Colors.amber),
            SizedBox(width: 8),
            Expanded(child: Text('Unlock Avoid Plus')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subtitle != null) ...[
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (trialBannerText() != null) ...[
              Text(
                trialBannerText()!,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blueGrey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              '${purchase.plusPriceString ?? '\$2.99'} · One-time purchase',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  await AppAnalytics.instance.trackEvent(
                    'purchase_plus_started',
                    parameters: {
                      'source_screen': 'plus_upgrade_dialog',
                      'entry_point': entryPoint,
                      'has_trial': purchase.hasActiveTrial,
                    },
                  );
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  final success = await purchase.purchasePlus();
                  await AppAnalytics.instance.trackEvent(
                    success
                        ? 'purchase_plus_completed'
                        : 'purchase_plus_failed',
                    parameters: {
                      'source_screen': 'plus_upgrade_dialog',
                      'entry_point': entryPoint,
                      'result': success ? 'success' : 'failure',
                    },
                  );
                  if (context.mounted && !success) {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Purchase failed or was cancelled.'),
                      ),
                    );
                  }
                },
                child: const Text('Unlock Now'),
              ),
            ),
            const SizedBox(height: 12),
            const Text('What you unlock:'),
            const SizedBox(height: 10),
            Row(children: [
              const Text('♾️', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n?.plusUnlockUnlimitedAvoidsHints ??
                      'Unlimited avoids, break game hints',
                ),
              ),
            ]),
            const SizedBox(height: 6),
            const Row(children: [
              Text('📅', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Expanded(child: Text('Full stats, history, and relapse patterns'))
            ]),
            const SizedBox(height: 6),
            const Row(children: [
              Text('🎯', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Expanded(child: Text('Goals and commitment check-ins'))
            ]),
            const SizedBox(height: 6),
            const Row(children: [
              Text('🔔', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Expanded(child: Text('Smarter reminders and follow-ups'))
            ]),
            const SizedBox(height: 6),
            const Row(children: [
              Text('🤝', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Expanded(child: Text('Trusted Support message after a relapse'))
            ]),
            const SizedBox(height: 6),
            const Row(children: [
              Text('🏠', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Expanded(child: Text('Home widget and cloud backup'))
            ]),
            const SizedBox(height: 6),
            const Row(children: [
              Text('🏅', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Expanded(child: Text('All badges, levels beyond 20, and export'))
            ]),
            const SizedBox(height: 20),
            if (!purchase.hasPurchasedPlus)
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: purchase.hasActiveTrial
                      ? null
                      : () async {
                          await AppAnalytics.instance.trackEvent(
                            'trial_start_started',
                            parameters: {
                              'source_screen': 'plus_upgrade_dialog',
                              'entry_point': entryPoint,
                            },
                          );
                          if (!ctx.mounted) return;
                          Navigator.pop(ctx);
                          final result = await purchase.startTrial();
                          final outcome = switch (result.outcome) {
                            TrialStartOutcome.started => 'success',
                            TrialStartOutcome.activeExisting => 'blocked',
                            TrialStartOutcome.expiredExisting => 'blocked',
                            TrialStartOutcome.unavailable => 'blocked',
                            TrialStartOutcome.cancelled => 'cancelled',
                            TrialStartOutcome.failed => 'failure',
                          };
                          await AppAnalytics.instance.trackEvent(
                            result.outcome == TrialStartOutcome.started
                                ? 'trial_start_completed'
                                : 'trial_start_failed',
                            parameters: {
                              'source_screen': 'plus_upgrade_dialog',
                              'entry_point': entryPoint,
                              'result': outcome,
                            },
                          );
                          if (!context.mounted) return;

                          final message = switch (result.outcome) {
                            TrialStartOutcome.started =>
                              'Free trial started. Full Plus access is unlocked until '
                                  '${dateFormat.format((result.status?.expiresAtUtc ?? DateTime.now().add(const Duration(days: 10))).toLocal())}, except cloud backup.',
                            TrialStartOutcome.activeExisting =>
                              'Your free trial is already active until '
                                  '${dateFormat.format((result.status?.expiresAtUtc ?? DateTime.now()).toLocal())}.',
                            TrialStartOutcome.expiredExisting =>
                              'This account already used its 10-day free trial. Purchase Plus to continue.',
                            TrialStartOutcome.unavailable => Theme.of(context)
                                        .platform ==
                                    TargetPlatform.iOS
                                ? 'Enable iCloud for Avoid to start the free trial.'
                                : 'Sign into Google Drive to start the free trial.',
                            TrialStartOutcome.cancelled =>
                              'Free trial start cancelled.',
                            TrialStartOutcome.failed =>
                              'Could not start the free trial right now. Please try again.',
                          };

                          messenger
                              .showSnackBar(SnackBar(content: Text(message)));
                        },
                  child: const Text('Start 10-Day Trial'),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  await AppAnalytics.instance.trackEvent(
                    'restore_purchase_started',
                    parameters: {
                      'source_screen': 'plus_upgrade_dialog',
                      'entry_point': entryPoint,
                    },
                  );
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  final restored = await purchase.restorePurchases();
                  await AppAnalytics.instance.trackEvent(
                    restored
                        ? 'restore_purchase_completed'
                        : 'restore_purchase_failed',
                    parameters: {
                      'source_screen': 'plus_upgrade_dialog',
                      'entry_point': entryPoint,
                      'result': restored ? 'success' : 'failure',
                    },
                  );
                  if (context.mounted) {
                    messenger.showSnackBar(SnackBar(
                      content: Text(
                        restored
                            ? 'Purchase restored!'
                            : 'No purchase found to restore.',
                      ),
                    ));
                  }
                },
                child: const Text('Restore Purchase'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Maybe later'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
