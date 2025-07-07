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
    final isPremium = subscriptionManager.isSubscribed;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7B44C6),
              Color(0xFFD1C4E9),
              Color(0xFFF7F7FC),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 28),
                // ロゴ画像を削除し、Finqlyテキストのみ
                Text(
                  "Finqly",
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w900,
                    fontSize: 34,
                    color: Color(0xFF7B44C6),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Emotion & Investing",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6D4DB0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
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
                _premiumTrendButton(context, loc, isPremium),
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
                ),
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
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Text(
                    "© SoruvaLab",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TrendPage（感情トレンド）はPremium限定
  Widget _premiumTrendButton(BuildContext context, AppLocalizations loc, bool isPremium) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.show_chart, size: 26),
        label: Text(loc.trendForecastTitle),
        onPressed: isPremium
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrendPage(subscriptionManager: subscriptionManager),
                  ),
                );
              }
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PremiumUnlockPage(
                      subscriptionManager: subscriptionManager,
                    ),
                  ),
                );
              },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(260, 54),
          backgroundColor: isPremium
              ? Colors.white
              : Colors.white.withOpacity(0.5),
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          shadowColor: Colors.purpleAccent.withOpacity(0.09),
        ),
      ),
    );
  }

  Widget _homeButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 26),
        label: Text(label),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(260, 54),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          shadowColor: Colors.purpleAccent.withOpacity(0.09),
        ),
      ),
    );
  }
}
