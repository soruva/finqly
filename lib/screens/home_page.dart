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
        title: Text(loc.appTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
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
            ElevatedButton(
              child: Text(loc.forecastTitle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ForecastPage(subscriptionManager: subscriptionManager),
                  ),
                );
              },
            ),
            ElevatedButton(
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
            ElevatedButton(
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
            ElevatedButton(
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
          ],
        ),
      ),
    );
  }
}
