import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/trial_status.dart';
import '../providers/purchase_provider.dart';

Future<void> showPlusUpgradeDialog(
  BuildContext context, {
  String? subtitle,
}) {
  final purchase = context.read<PurchaseProvider>();
  final messenger = ScaffoldMessenger.of(context);
  final trialStatus = purchase.trialStatus;
  final dateFormat = DateFormat.yMMMd();

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
    builder: (ctx) => AlertDialog(
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
                Navigator.pop(ctx);
                final success = await purchase.purchasePlus();
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
          const Row(children: [
            Text('♾️', style: TextStyle(fontSize: 16)),
            SizedBox(width: 8),
            Expanded(child: Text('Unlimited habits'))
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
                        Navigator.pop(ctx);
                        final result = await purchase.startTrial();
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
                Navigator.pop(ctx);
                final restored = await purchase.restorePurchases();
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
  );
}
