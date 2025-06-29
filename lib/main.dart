import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:finqly/l10n/generated/app_localizations.dart';
import 'package:finqly/theme/colors.dart';
import 'package:finqly/screens/diagnosis_page.dart';
import 'package:finqly/screens/settings_page.dart';
import 'package:finqly/screens/education_page.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/screens/forecast_page.dart';
import 'package:finqly/screens/splash_screen.dart';
import 'package:finqly/services/subscription_manager.dart';

void main() {
  runApp(const FinqlyApp());
}

class FinqlyApp extends StatefulWidget {
  const FinqlyApp({super.key});

  @override
  State<FinqlyApp> createState() => _FinqlyAppState();
}

class _FinqlyAppState extends State<FinqlyApp> {
  final SubscriptionManager _subscriptionManager = SubscriptionManager();
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    //_subscriptionManager.loadSubscriptionStatus();
  }

  void _setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  void _setTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finqly',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Nunito',
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: AppColors.primary,
      ),
      themeMode: _themeMode,
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('pt'),
        Locale('de'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: SplashScreen(
        subscriptionManager: _subscriptionManager,
        currentLocale: _locale,
        onLocaleChanged: _setLocale,
        onThemeChanged: _setTheme,
      ),
    );
  }
}

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
                    builder: (_) => const EducationPage(),
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
