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
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // アプリ名だけ大きく中央表示
                Text(
                  loc.appTitle,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Emotion & Investing",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentPurple.withOpacity(0.95),
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 40),
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
                _premiumTrendButton(context, loc),
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
                const SizedBox(height: 40),
                Text(
                  "© SoruvaLab",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.withOpacity(0.55),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // プレミアム限定のトレンドグラフボタン
  Widget _premiumTrendButton(BuildContext context, AppLocalizations loc) {
    final isPremium = subscriptionManager.isSubscribed;
    return _homeButton(
      context,
      icon: Icons.show_chart,
      label: loc.trendForecastTitle,
      onTap: isPremium
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
      isPremium: isPremium,
    );
  }

  // 共通ホームボタン（角丸・高さ揃え・カラー美化）
  Widget _homeButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap,
      bool isPremium = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
      child: SizedBox(
        width: 290,
        height: 60,
        child: ElevatedButton.icon(
          icon: Icon(icon, size: 26),
          label: Text(label),
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: isPremium
                ? AppColors.accentPurple.withOpacity(0.13)
                : Colors.white,
            foregroundColor: isPremium
                ? AppColors.accentPurple
                : AppColors.primary,
            textStyle: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: isPremium ? 4 : 2,
            shadowColor: Colors.purpleAccent.withOpacity(0.07),
          ),
        ),
      ),
    );
  }
}
