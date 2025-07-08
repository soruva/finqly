import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/theme/colors.dart';
import 'package:finqly/screens/splash_screen.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/services/user_subscription_status.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  UserSubscriptionStatus.listenToPurchaseUpdates();
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

  // 言語変更
  void _setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  // ダーク/ライト切替
  void _setTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finqly',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
        ).copyWith(
          secondary: AppColors.accent,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: const Color(0xFF19162D),
        colorScheme: ThemeData.dark().colorScheme.copyWith(
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
      ),
      themeMode: _themeMode,
      locale: _locale,
      supportedLocales: const [
        Locale('de'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('pt'),
      ],
      // Flutter 3以降なら↓これでOK
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      // 重要：SplashScreenにPremium管理/言語/テーマを渡す
      home: SplashScreen(
        subscriptionManager: _subscriptionManager,
        currentLocale: _locale,
        onLocaleChanged: _setLocale,
        onThemeChanged: _setTheme,
      ),
    );
  }
}
