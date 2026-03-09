import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avoid_todo/l10n/app_localizations.dart';
import 'package:avoid_todo/constants/themes.dart';
import 'package:avoid_todo/constants/colors.dart';
import 'package:avoid_todo/screens/home.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      titleKey: (l10n) => l10n.onboardingWelcomeTitle,
      descKey: (l10n) => l10n.onboardingWelcomeDesc,
      icon: Icons.auto_awesome,
      color: tdAvoidRed,
    ),
    OnboardingData(
      titleKey: (l10n) => l10n.onboardingTagsTitle,
      descKey: (l10n) => l10n.onboardingTagsDesc,
      icon: Icons.label_important,
      color: Colors.blue,
    ),
    OnboardingData(
      titleKey: (l10n) => l10n.onboardingMoneyTitle,
      descKey: (l10n) => l10n.onboardingMoneyDesc,
      icon: Icons.attach_money,
      color: Colors.green,
    ),
    OnboardingData(
      titleKey: (l10n) => l10n.onboardingRelapseTitle,
      descKey: (l10n) => l10n.onboardingRelapseDesc,
      icon: Icons.history,
      color: Colors.orange,
    ),
    OnboardingData(
      titleKey: (l10n) => l10n.onboardingBadgesTitle,
      descKey: (l10n) => l10n.onboardingBadgesDesc,
      icon: Icons.emoji_events,
      color: Colors.purple,
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppThemes.darkBackground : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  final data = _pages[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: data.color.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            data.icon,
                            size: 80,
                            color: data.color,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          data.titleKey(l10n),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          data.descKey(l10n),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: isDark ? Colors.white70 : Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(
                      l10n.skip,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? tdAvoidRed
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _pages.length - 1) {
                        _completeOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdAvoidRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? l10n.getStarted
                          : l10n.next,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String Function(AppLocalizations) titleKey;
  final String Function(AppLocalizations) descKey;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.titleKey,
    required this.descKey,
    required this.icon,
    required this.color,
  });
}
