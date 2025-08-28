// /workspaces/finqly/lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/theme/theme.dart';
import 'package:finqly/screens/splash_screen.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/services/iap_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  void _setLocale(Locale newLocale) => setState(() => _locale = newLocale);
  void _setTheme(bool isDarkMode) =>
      setState(() => _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light);

  @override
  void initState() {
    super.initState();

    _subscriptionManager.init();

    IapService.instance.init();

    _purchaseSub = IapService.instance.purchaseStream.listen((purchases) async {
      for (final p in purchases) {
        switch (p.status) {
          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            await _subscriptionManager.setSubscribed(true);
            break;
          case PurchaseStatus.error:
            break;
          case PurchaseStatus.pending:
          case PurchaseStatus.canceled:
            break;
        }
        if (p.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(p);
        }
      }
    });
  }

  @override
  void dispose() {
    _purchaseSub?.cancel();
    _subscriptionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finqly',

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,

      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,

      home: SplashScreen(
        subscriptionManager: _subscriptionManager,
        currentLocale: _locale,
        onLocaleChanged: _setLocale,
        onThemeChanged: _setTheme,
      ),
    );
  }
}
