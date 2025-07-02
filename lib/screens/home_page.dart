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
        title: Text(loc.appTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B44C6), Color(0xFF72C6EF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(220, 56),
                    textStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 2,
                  ),
                  child: Text(loc.startButton),
                  onPressed: () {
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
                const SizedBox(height: 22),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(220, 56),
                    textStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 2,
                  ),
                  child: Text(loc.forecastTitle),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ForecastPage(subscriptionManager: subscriptionManager),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 22),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(220, 56),
                    textStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 2,
                  ),
                  child: Text(loc.premiumUnlockTitle),
                  onPressed: () {
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
                const SizedBox(height: 22),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(220, 56),
                    textStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 2,
                  ),
                  child: Text(loc.educationTitle),
                  onPressed: () {
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
                const SizedBox(height: 22),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(220, 56),
                    textStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 2,
                  ),
                  child: Text(loc.settingsTitle),
                  onPressed: () {
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
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
