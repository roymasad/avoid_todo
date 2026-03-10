import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../helpers/rating_helper.dart';
import '../l10n/app_localizations.dart';

enum _RatingPhase { stars, highRating, lowRating }

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _selectedStars = 0;
  _RatingPhase _phase = _RatingPhase.stars;
  final _feedbackController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _onContinue() {
    setState(() {
      _phase = _selectedStars >= 4
          ? _RatingPhase.highRating
          : _RatingPhase.lowRating;
    });
  }

  Future<void> _onDismiss() async {
    await RatingHelper.recordDialogShown();
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _onRateNow() async {
    await RatingHelper.openStoreListing();
    await RatingHelper.recordHighRating();
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _onSubmitFeedback() async {
    setState(() => _submitting = true);
    await RatingHelper.submitFeedback(_feedbackController.text.trim());
    await RatingHelper.recordDialogShown();
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.ratingThanks),
      ),
    );
  }

  Widget _buildStarRow() {
    final primary = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final starNum = i + 1;
        return IconButton(
          iconSize: 36,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          constraints: const BoxConstraints(),
          icon: Icon(
            starNum <= _selectedStars
                ? Icons.star_rounded
                : Icons.star_outline_rounded,
            color: starNum <= _selectedStars ? primary : Colors.grey.shade400,
          ),
          onPressed: () => setState(() => _selectedStars = starNum),
        );
      }),
    );
  }

  Widget _buildStarsPhase(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Icon(Icons.star_rounded,
            size: 40, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 12),
        Text(
          l10n.ratingDialogTitle,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.ratingDialogSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        _buildStarRow(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: _onDismiss,
              child: Text(l10n.ratingDialogNotNow),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: tdBlue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              onPressed: _selectedStars > 0 ? _onContinue : null,
              child: Text(l10n.ratingDialogContinue),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHighRatingPhase(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Icon(Icons.favorite_rounded,
            size: 40, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 12),
        Text(
          l10n.ratingHighTitle,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.ratingHighBody,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: _onDismiss,
              child: Text(l10n.ratingHighNoThanks),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: tdBlue,
                foregroundColor: Colors.white,
              ),
              onPressed: _onRateNow,
              child: Text(l10n.ratingHighRateNow),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLowRatingPhase(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Icon(Icons.edit_note_rounded,
            size: 40, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 12),
        Text(
          l10n.ratingLowTitle,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.ratingLowBody,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _feedbackController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: l10n.ratingLowHint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: _submitting ? null : _onDismiss,
              child: Text(l10n.ratingLowSkip),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: tdBlue,
                foregroundColor: Colors.white,
              ),
              onPressed: _submitting ? null : _onSubmitFeedback,
              child: _submitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(l10n.ratingLowSend),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
        child: switch (_phase) {
          _RatingPhase.stars => _buildStarsPhase(l10n),
          _RatingPhase.highRating => _buildHighRatingPhase(l10n),
          _RatingPhase.lowRating => _buildLowRatingPhase(l10n),
        },
      ),
    );
  }
}
