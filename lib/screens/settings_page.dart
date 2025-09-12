// /workspaces/finqly/lib/screens/settings_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/screens/legal_webview_page.dart';
import 'package:finqly/screens/emotion_history_page.dart';
import 'package:finqly/screens/report_page.dart';
import 'package:finqly/services/notification_service.dart';

class SettingsPage extends StatefulWidget {
  final Locale currentLocale;
  final void Function(Locale) onLocaleChanged;
  /// true = dark mode
  final void Function(bool) onThemeChanged;
  final SubscriptionManager subscriptionManager;

  const SettingsPage({
    required this.subscriptionManager,
    required this.currentLocale,
    required this.onLocaleChanged,
    required this.onThemeChanged,
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool? _isDark;
  String? _appVersion;
  bool _restoring = false;

  bool _dailyOn = true;
  bool _weeklyOn = true;

  static const _prefsDaily = 'notif_daily_on';
  static const _prefsWeekly = 'notif_weekly_on';

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('de'),
  ];

  static const Map<String, String> _nativeLanguageLabels = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'pt': 'Português',
    'de': 'Deutsch',
  };

  @override
  void initState() {
    super.initState();
    _loadVersion();
    _loadNotifPrefs();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _appVersion = '${info.version} (${info.buildNumber})';
    });
  }

  Future<void> _loadNotifPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _dailyOn = prefs.getBool(_prefsDaily) ?? true;
      _weeklyOn = prefs.getBool(_prefsWeekly) ?? true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isDark ??= Theme.of(context).brightness == Brightness.dark;
  }

  void _changeLanguage(Locale locale) {
    if (!supportedLocales.contains(locale)) return;
    widget.onLocaleChanged(locale);
  }

  void _toggleTheme(bool value) {
    setState(() => _isDark = value);
    widget.onThemeChanged(value);
  }

  void _openLegalPage(String title, String fileName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LegalWebViewPage(
          title: title,
          assetPath: 'assets/legal/$fileName',
        ),
      ),
    );
  }

  Future<void> _openManageSubscriptions() async {
    final uri = Uri.parse(
      'https://play.google.com/store/account/subscriptions'
      '?sku=finqly_premium&package=com.soruvalab.finqly',
    );
    final messenger = ScaffoldMessenger.of(context);
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Could not open subscription page.')),
        );
      }
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not open subscription page.')),
      );
    }
  }

  Future<void> _toggleDaily(bool v) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _dailyOn = v);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsDaily, v);
      await NotificationService().scheduleDailyNineAM(enabled: v);
    } catch (e) {
      setState(() => _dailyOn = !v);
      messenger.showSnackBar(SnackBar(content: Text('Daily reminder error: $e')));
    }
  }

  Future<void> _toggleWeekly(bool v) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _weeklyOn = v);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsWeekly, v);
      await NotificationService().scheduleWeeklyReportMondayNineAM(enabled: v);
    } catch (e) {
      setState(() => _weeklyOn = !v);
      messenger.showSnackBar(SnackBar(content: Text('Weekly report reminder error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final localeFromContext = Localizations.localeOf(context);
    final effectiveLocale = supportedLocales.contains(localeFromContext)
        ? localeFromContext
        : (supportedLocales.contains(widget.currentLocale)
            ? widget.currentLocale
            : const Locale('en'));

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settingsTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            // Emotion history
            ListTile(
              leading: const Icon(Icons.history),
              title: Text(loc.emotionHistoryTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmotionHistoryPage(
                      subscriptionManager: widget.subscriptionManager,
                    ),
                  ),
                );
              },
            ),

            const Divider(height: 32),

            // Language
            Text(loc.language, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            DropdownButton<Locale>(
              value: effectiveLocale,
              isExpanded: true,
              onChanged: (Locale? newLocale) {
                if (newLocale != null) _changeLanguage(newLocale);
              },
              items: supportedLocales.map((locale) {
                final label = _nativeLanguageLabels[locale.languageCode] ?? locale.languageCode;
                return DropdownMenuItem<Locale>(
                  value: locale,
                  child: Text(label),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Theme
            Text(loc.darkMode, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text((_isDark ?? false) ? (loc.darkModeOn) : (loc.darkModeOff)),
              value: _isDark ?? false,
              onChanged: _toggleTheme,
            ),

            const SizedBox(height: 32),

            // Reports & Notifications
            Text('Reports & notifications', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            ListTile(
              leading: const Icon(Icons.insights),
              title: const Text('Open Weekly Report'),
              subtitle: const Text('See last 7 days trend'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportPage()));
              },
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Daily reminder (9:00)'),
              subtitle: const Text('Keep your check-in streak'),
              value: _dailyOn,
              onChanged: _toggleDaily,
              secondary: const Icon(Icons.alarm),
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Weekly report reminder (Mon 9:00)'),
              subtitle: const Text('Get your weekly summary'),
              value: _weeklyOn,
              onChanged: _toggleWeekly,
              secondary: const Icon(Icons.event_note),
            ),

            const SizedBox(height: 24),

            // Legal
            Text(loc.other, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: Text(loc.privacyTitle),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _openLegalPage(loc.privacyTitle, 'privacy.html'),
            ),
            ListTile(
              leading: const Icon(Icons.gavel),
              title: Text(loc.termsTitle),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _openLegalPage(loc.termsTitle, 'terms.html'),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(loc.disclaimerTitle),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _openLegalPage(loc.disclaimerTitle, 'disclaimer.html'),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: Text(loc.faqTitle),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _openLegalPage(loc.faqTitle, 'faq.html'),
            ),

            // Manage subscription
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: const Text('Manage subscription (Play Store)'),
              trailing: const Icon(Icons.open_in_new),
              onTap: _openManageSubscriptions,
            ),

            const Divider(height: 32),

            // Restore purchases
            ListTile(
              leading: const Icon(Icons.restore),
              title: Text(loc.restorePurchasesTitle),
              trailing: _restoring
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
              onTap: () async {
                if (_restoring) return;
                final messenger = ScaffoldMessenger.of(context);
                setState(() => _restoring = true);
                try {
                  await widget.subscriptionManager.restorePurchases();
                  messenger.showSnackBar(
                    SnackBar(content: Text(loc.restorePurchasesDone)),
                  );
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('Restore error: $e')),
                  );
                } finally {
                  if (mounted) setState(() => _restoring = false);
                }
              },
            ),

            const SizedBox(height: 8),

            AboutListTile(
              icon: const Icon(Icons.info),
              applicationIcon: const Icon(Icons.apps),
              applicationName: 'Finqly',
              applicationVersion: _appVersion ?? '1.0.0',
              child: const Text('About'),
            ),
          ],
        ),
      ),
    );
  }
}
