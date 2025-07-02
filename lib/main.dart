import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/theme/colors.dart';
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
      // <<==== ここが重要！SplashScreenに各種パラメータを渡す ====>>
      home: SplashScreen(
        subscriptionManager: _subscriptionManager,
        currentLocale: _locale,
        onLocaleChanged: _setLocale,
        onThemeChanged: _setTheme,
      ),
    );
  }
}
