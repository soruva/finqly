import 'package:flutter/material.dart';
import 'package:finqly/l10n/app_localizations.dart'; // ← セミコロン忘れずに
import 'package:finqly/theme/colors.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/screens/legal_webview_page.dart';

class SettingsPage extends StatefulWidget {
  final Locale currentLocale;
  final Function(Locale) onLocaleChanged;
  final Function(bool) onThemeChanged;
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
  late bool isDark;

  @override
  void initState() {
    super.initState();
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    isDark = brightness == Brightness.dark;
  }

  void _changeLanguage(Locale locale) {
    widget.onLocaleChanged(locale);
  }

  void _toggleTheme(bool value) {
    setState(() => isDark = value);
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
    final loc = AppLocalizations.of(context)!; // ← Null safety！

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settingsTitle),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Text(loc.language, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            DropdownButton<Locale>(
              value: widget.currentLocale,
              onChanged: (Locale? newLocale) {
                if (newLocale != null) _changeLanguage(newLocale);
              },
              items: [
                DropdownMenuItem(
                  value: const Locale('en'), 
                  child: Text(loc.languageEnglish),
                ),  
                DropdownMenuItem(
                  value: const Locale('es'), 
                  child: Text(loc.languageSpanish),
                ),  
                DropdownMenuItem(
                  value: const Locale('fr'), 
                  child: Text(loc.languageFrench),
                ),  
                DropdownMenuItem(
                  value: const Locale('pt'), 
                  child: Text(loc.languagePortuguese),
                ),  
                DropdownMenuItem(
                  value: const Locale('de'), 
                  child: Text(loc.languageGerman),
                ),  
              ],
            ),
            const SizedBox(height: 24),
            Text(loc.darkMode, style: Theme.of(context).textTheme.titleLarge),
            Switch(value: isDark, onChanged: _toggleTheme),
            const SizedBox(height: 32),
            Text(loc.other, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              onTap: () => _openLegalPage('Privacy Policy', 'privacy.html'),
            ),
            ListTile(
              leading: const Icon(Icons.gavel),
              title: const Text('Terms of Service'),
              onTap: () => _openLegalPage('Terms of Service', 'terms.html'),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Disclaimer'),
              onTap: () => _openLegalPage('Disclaimer', 'disclaimer.html'),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('FAQ'),
              onTap: () => _openLegalPage('FAQ', 'faq.html'),
            ),
          ],
        ),
      ),
    );
  }
}
