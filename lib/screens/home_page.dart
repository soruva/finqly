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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8267BE), Color(0xFF47C6E6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    loc.appTitle,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
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
                  const SizedBox(height: 10),
                  Text(
                    "Emotion & Investing",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB39DDB),
                      fontSize: 16,
                      letterSpacing: 0.7,
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
                    isPremium: true,
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
                  const SizedBox(height: 36),
                  Text(
                    "© SoruvaLab",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.55),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _premiumTrendButton(BuildContext context, AppLocalizations loc) {
    return ValueListenableBuilder<bool>(
      valueListenable: subscriptionManager.isSubscribedNotifier,
      builder: (context, isPremium, child) {
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
      },
    );
  }

  Widget _homeButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPremium = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
      child: SizedBox(
        width: 295,
        height: 62,
        child: ElevatedButton.icon(
          icon: Icon(
            icon, 
            size: 28, 
            color: isPremium ? Colors.deepPurple : AppColors.primary,
          ),
          label: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
                color: isPremium ? Colors.deepPurple : AppColors.primary,
              ),
            ),
          ),
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: isPremium
                ? Colors.white.withOpacity(0.85)
                : Colors.white.withOpacity(0.93),
            foregroundColor: isPremium ? Colors.deepPurple : AppColors.primary,
            shadowColor: Colors.black.withOpacity(0.09),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(21),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          ),
        ),
      ),
    );
  }
}
