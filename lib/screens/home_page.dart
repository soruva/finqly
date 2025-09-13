// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:finqly/theme/colors.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/screens/diagnosis_page.dart';
import 'package:finqly/screens/forecast_page.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/screens/education_page.dart';
import 'package:finqly/screens/settings_page.dart';
import 'package:finqly/screens/trend_page.dart';
import 'package:finqly/services/subscription_manager.dart';

class MyHomePage extends StatelessWidget {
  final SubscriptionManager subscriptionManager;
  final Locale currentLocale;
  final Function(Locale) onLocaleChanged;
  final Function(bool) onThemeChanged;

  const MyHomePage({
    super.key,
    required this.subscriptionManager,
    required this.currentLocale,
    required this.onLocaleChanged,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8267BE), Color(0xFF47C6E6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 32, 18, 120),
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    Text(
                      'Finqly',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 7,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Emotion & Investing",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB39DDB),
                        fontSize: 16,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Start
                _homeButton(
                  context,
                  icon: Icons.flash_on,
                  label: loc.startButton,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DiagnosisPage(
                          subscriptionManager: subscriptionManager,
                        ),
                      ),
                    );
                  },
                ),

                // Forecast
                _homeButton(
                  context,
                  icon: Icons.trending_up,
                  label: loc.forecastTitle,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ForecastPage(
                          subscriptionManager: subscriptionManager,
                        ),
                      ),
                    );
                  },
                ),

                // Trend (Premium)
                ValueListenableBuilder<bool>(
                  valueListenable: subscriptionManager.isSubscribedNotifier,
                  builder: (_, isPremium, __) {
                    return _homeButton(
                      context,
                      icon: Icons.show_chart,
                      label: loc.trendForecastTitle,
                      trailing: !isPremium
                          ? const Icon(Icons.lock, color: Colors.deepPurple, size: 20)
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => isPremium
                                ? TrendPage(subscriptionManager: subscriptionManager)
                                : PremiumUnlockPage(subscriptionManager: subscriptionManager),
                          ),
                        );
                      },
                    );
                  },
                ),

                // Unlock Premium
                _homeButton(
                  context,
                  icon: Icons.workspace_premium,
                  label: loc.premiumUnlockTitle,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PremiumUnlockPage(
                          subscriptionManager: subscriptionManager,
                        ),
                      ),
                    );
                  },
                  isPremiumStyle: true,
                ),

                // Education
                _homeButton(
                  context,
                  icon: Icons.menu_book,
                  label: loc.educationTitle,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EducationPage(
                          subscriptionManager: subscriptionManager,
                        ),
                      ),
                    );
                  },
                ),

                // Settings
                _homeButton(
                  context,
                  icon: Icons.settings,
                  label: loc.settingsTitle,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SettingsPage(
                          subscriptionManager: subscriptionManager,
                          currentLocale: currentLocale,
                          onLocaleChanged: onLocaleChanged,
                          onThemeChanged: onThemeChanged,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      // --- Bottom area ---
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(18, 0, 18, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Premium誘導バー（非購読時のみ）
            ValueListenableBuilder<bool>(
              valueListenable: subscriptionManager.isSubscribedNotifier,
              builder: (context, isPremium, _) {
                if (isPremium) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5D33C4),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock, color: Colors.amber),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "You're close to unlocking even better insights.",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            // --- SoruvaLab ブランドラベル ---
            const Text(
              "SoruvaLab",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Widget? trailing,
    bool isPremiumStyle = false,
  }) {
    final fg = isPremiumStyle ? Colors.deepPurple : AppColors.primary;
    final bg = isPremiumStyle
        ? Colors.white.withOpacity(0.90)
        : Colors.white.withOpacity(0.95);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
      child: SizedBox(
        height: 62,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: fg,
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.08),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
            padding: const EdgeInsets.symmetric(horizontal: 18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 26, color: fg),
                  const SizedBox(width: 14),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 160,
                    child: Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: fg,
                      ),
                    ),
                  ),
                ],
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }
}
