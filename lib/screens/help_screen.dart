import 'package:flutter/material.dart';
import 'package:avoid_todo/l10n/app_localizations.dart';
import 'package:avoid_todo/constants/themes.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppThemes.darkBackground : AppThemes.lightBackground,
      appBar: AppBar(
        title: Text(l10n.helpTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHelpSection(
            context,
            l10n.helpWhatIsAvoidTitle,
            l10n.helpWhatIsAvoidDesc,
            Icons.info_outline,
            Colors.blue,
          ),
          const SizedBox(height: 24),
          Text(
            'FAQ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildFAQItem(context, l10n.faq1Question, l10n.faq1Answer),
          _buildFAQItem(context, l10n.faq2Question, l10n.faq2Answer),
          _buildFAQItem(context, l10n.faq3Question, l10n.faq3Answer),
          _buildFAQItem(context, l10n.faq4Question, l10n.faq4Answer),
          _buildFAQItem(context, l10n.faq5Question, l10n.faq5Answer),
          _buildFAQItem(context, l10n.faq6Question, l10n.faq6Answer),
          _buildFAQItem(context, l10n.faq7Question, l10n.faq7Answer),
          _buildFAQItem(context, l10n.faq8Question, l10n.faq8Answer),
          _buildFAQItem(context, l10n.faq9Question, l10n.faq9Answer),
          const SizedBox(height: 32),
          _buildHelpSection(
            context,
            l10n.badges,
            l10n.onboardingBadgesDesc,
            Icons.emoji_events,
            Colors.purple,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context, String title, String desc,
      IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppThemes.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            desc,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
