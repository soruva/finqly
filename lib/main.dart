// lib/main.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/theme/theme.dart';
import 'package:finqly/screens/splash_screen.dart';
import 'package:finqly/screens/report_page.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/services/iap_service.dart';
import 'package:finqly/services/notification_service.dart';
import 'package:finqly/services/purchase_verification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FinqlyApp());

  // ignore: discarded_futures
  Future(() async {
    try {
      final notif = NotificationService();
      await notif.init();
      await notif.scheduleDailyNineAM(enabled: true);
      await notif.scheduleWeeklyReportMondayNineAM(enabled: true);
    } catch (e, st) {
      debugPrint('Notification init/schedule failed: $e\n$st');
    }
  });
}

class FinqlyApp extends StatefulWidget {
  const FinqlyApp({super.key});

  @override
  State<FinqlyApp> createState() => _FinqlyAppState();
}

class _FinqlyAppState extends State<FinqlyApp> {
  final _navKey = GlobalKey<NavigatorState>();

  final SubscriptionManager _subscriptionManager = SubscriptionManager();
  late Locale _locale;
  ThemeMode _themeMode = ThemeMode.light;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;
  StreamSubscription<String>? _notifTapSub;

  void _setLocale(Locale newLocale) => setState(() => _locale = newLocale);
  void _setTheme(bool isDarkMode) =>
      setState(() => _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light);

  @override
  void initState() {
    super.initState();

    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    _locale = deviceLocale ?? const Locale('en');

    _subscriptionManager.init();

    IapService.instance.init();
    _purchaseSub = IapService.instance.purchaseStream.listen((purchases) async {
      for (final p in purchases) {
        try {
          switch (p.status) {
            case PurchaseStatus.purchased:
            case PurchaseStatus.restored:
              final ok = await PurchaseVerification.verify(p);
              if (ok) {
                await _subscriptionManager.setSubscribed(true);
              } else {
                debugPrint('Purchase verification failed for ${p.productID}');
              }
              break;
            case PurchaseStatus.error:
              debugPrint('Purchase error: ${p.error}');
              break;
            case PurchaseStatus.pending:
            case PurchaseStatus.canceled:
              break;
          }
          if (p.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(p);
          }
        } catch (e, st) {
          debugPrint('Purchase handling failed: $e\n$st');
        }
      }
    });

    _notifTapSub = NotificationService().onTap.listen((payload) {
      final nav = _navKey.currentState;
      if (nav == null) return;

      if (nav.canPop()) {
        nav.popUntil((r) => r.isFirst);
      }
      if (payload == 'open_report') {
        nav.push(MaterialPageRoute(builder: (_) => const ReportPage()));
      } else if (payload == 'open_home') {
        // do nothing
      }
    }, onError: (e, st) {
      debugPrint('Notification tap stream error: $e\n$st');
    });
  }

  @override
  void dispose() {
    _purchaseSub?.cancel();
    _notifTapSub?.cancel();
    _subscriptionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
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
