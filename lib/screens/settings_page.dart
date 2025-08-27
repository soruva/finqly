import 'package:flutter/material.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/screens/legal_webview_page.dart';
import 'package:finqly/screens/emotion_history_page.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatefulWidget {
  final Locale currentLocale;
  final void Function(Locale) onLocaleChanged;
  final void Function(bool) onThemeChanged; // true = dark
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

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('de'),
  ];

  @override
  void initState() {
    super.initState();
    _loadVersion();
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final effectiveLocale = supportedLocales.contains(widget.currentLocale)
        ? widget.currentLocale
        : const Locale('en');

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settingsTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
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

            Text(loc.language, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            DropdownButton<Locale>(
              value: effectiveLocale,
              isExpanded: true,
              onChanged: (Locale? newLocale) {
                if (newLocale != null) _changeLanguage(newLocale);
              },
              items: [
                DropdownMenuItem(value: const Locale('en'), child: Text(loc.languageEnglish)),
                DropdownMenuItem(value: const Locale('es'), child: Text(loc.languageSpanish)),
                DropdownMenuItem(value: const Locale('fr'), child: Text(loc.languageFrench)),
                DropdownMenuItem(value: const Locale('pt'), child: Text(loc.languagePortuguese)),
                DropdownMenuItem(value: const Locale('de'), child: Text(loc.languageGerman)),
              ],
            ),

            const SizedBox(height: 24),

            Text(loc.darkMode, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text((_isDark ?? false) ? (loc.darkModeOn) : (loc.darkModeOff)),
              value: _isDark ?? false,
              onChanged: _toggleTheme,
            ),

            const SizedBox(height: 32),

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

            const Divider(height: 32),

            ListTile(
              leading: const Icon(Icons.restore),
              title: Text(loc.restorePurchasesTitle),
              onTap: () async {
                await widget.subscriptionManager.restorePurchases();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.restorePurchasesDone)),
                );
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
