// /workspaces/finqly/lib/screens/settings_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

  bool _loadingReminders = true;
  bool _dailyEnabled = true;
  bool _weeklyEnabled = true;

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
    _loadReminderStates();
  }

  Future<void> _loadReminderStates() async {
    try {
      final states = await NotificationService().getEnabledStates();
      if (!mounted) return;
      setState(() {
        _dailyEnabled = states['daily'] ?? true;
        _weeklyEnabled = states['weekly'] ?? true;
        _loadingReminders = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingReminders = false);
    }
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _appVersion = '${info.version} (${info.buildNumber})';
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
    final loc = AppLocalizations.of(context)!;
    final uri = Uri.parse(
      'https://play.google.com/store/account/subscriptions'
      '?sku=finqly_premium&package=com.soruvalab.finqly',
    );
    final messenger = ScaffoldMessenger.of(context);
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) {
        messenger.showSnackBar(
          SnackBar(content: Text(loc.openSubscriptionPageFailed)),
        );
      }
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(loc.openSubscriptionPageFailed)),
      );
    }
  }

  Future<void> _onDailyToggled(bool value) async {
    final loc = AppLocalizations.of(context)!;
    final svc = NotificationService();
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _dailyEnabled = value);
    try {
      if (value) {
        await svc.scheduleDailyNineAM(enabled: true);
        messenger.showSnackBar(SnackBar(content: Text(loc.dailyReminderEnabledMsg)));
      } else {
        await svc.cancelDaily();
        messenger.showSnackBar(SnackBar(content: Text(loc.dailyReminderDisabledMsg)));
      }
    } catch (e) {
      setState(() => _dailyEnabled = !value);
      messenger.showSnackBar(SnackBar(content: Text('${loc.purchaseErrorPrefix} $e')));
    }
  }

  Future<void> _onWeeklyToggled(bool value) async {
    final loc = AppLocalizations.of(context)!;
    final svc = NotificationService();
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _weeklyEnabled = value);
    try {
      if (value) {
        await svc.scheduleWeeklyReportMondayNineAM(enabled: true);
        messenger.showSnackBar(SnackBar(content: Text(loc.weeklyReminderEnabledMsg)));
      } else {
        await svc.cancelWeekly();
        messenger.showSnackBar(SnackBar(content: Text(loc.weeklyReminderDisabledMsg)));
      }
    } catch (e) {
      setState(() => _weeklyEnabled = !value);
      messenger.showSnackBar(SnackBar(content: Text('${loc.purchaseErrorPrefix} $e')));
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
            // History
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

            // Dark mode
            Text(loc.darkMode, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text((_isDark ?? false) ? loc.darkModeOn : loc.darkModeOff),
              value: _isDark ?? false,
              onChanged: _toggleTheme,
            ),

            const SizedBox(height: 32),

            // Reports & notifications
            Text(
              loc.reportsTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            // Open weekly report
            ListTile(
              leading: const Icon(Icons.insights),
              title: Text(loc.openWeeklyReport),
              subtitle: Text(loc.openWeeklyReportSub),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportPage()),
                );
              },
            ),

            // Reminders
            _loadingReminders
                ? ListTile(
                    leading: const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    title: Text(loc.loadingReminders),
                  )
                : SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.alarm),
                    title: Text(loc.dailyReminderTitle),
                    subtitle: Text(loc.dailyReminderSub),
                    value: _dailyEnabled,
                    onChanged: _onDailyToggled,
                  ),

            if (!_loadingReminders)
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                secondary: const Icon(Icons.date_range),
                title: Text(loc.weeklyReminderTitle),
                subtitle: Text(loc.weeklyReminderSub),
                value: _weeklyEnabled,
                onChanged: _onWeeklyToggled,
              ),

            const SizedBox(height: 24),

            // Other
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

            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: Text(loc.manageSubscriptionTitle),
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
                    SnackBar(content: Text('${loc.restoreErrorPrefix} $e')),
                  );
                } finally {
                  if (mounted) setState(() => _restoring = false);
                }
              },
            ),

            const SizedBox(height: 8),

            // About
            AboutListTile(
              icon: const Icon(Icons.info),
              applicationIcon: const Icon(Icons.apps),
              applicationName: 'Finqly',
              applicationVersion: _appVersion ?? '1.0.0',
              child: Text(loc.about),
            ),
          ],
        ),
      ),
    );
  }
}
