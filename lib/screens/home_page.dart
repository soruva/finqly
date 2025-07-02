import 'package:flutter/material.dart';
import 'package:finqly/theme/colors.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/screens/diagnosis_page.dart';
import 'package:finqly/screens/forecast_page.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/screens/education_page.dart';
import 'package:finqly/screens/settings_page.dart';
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
      appBar: AppBar(
        title: Text(
          loc.appTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 26,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7B44C6),
              Color(0xFF9A5DF0),
              Color(0xFF72C6EF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 60),
                Image.asset(
                  'assets/images/finqly_logo.png',
                  width: 88,
                  height: 88,
                ),
                const SizedBox(height: 16),
                Text(
                  "Emotion & Investing",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.92),
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 38),
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
                const SizedBox(height: 50),
                Text(
                  "© SoruvaLab",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _homeButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 26),
        label: Text(label),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(240, 58),
          backgroundColor: Colors.white.withOpacity(0.94),
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 3,
          shadowColor: Colors.purpleAccent.withOpacity(0.08),
        ),
      ),
    );
  }
}
