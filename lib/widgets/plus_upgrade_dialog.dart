import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/purchase_provider.dart';

Future<void> showPlusUpgradeDialog(
  BuildContext context, {
  String? subtitle,
}) {
  final purchase = context.read<PurchaseProvider>();
  final messenger = ScaffoldMessenger.of(context);

  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.star, color: Colors.amber),
          SizedBox(width: 8),
          Text('Unlock Avoid Plus'),
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
          Text(
            '${purchase.plusPriceString ?? '\$2.99'} · One-time purchase',
            style: const TextStyle(fontWeight: FontWeight.bold),
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
        ],
      ),
      actions: [
        TextButton(
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
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Maybe later'),
        ),
        FilledButton(
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
      ],
    ),
  );
}
