import 'package:flutter/material.dart';
import 'package:finqly/l10n/app_localizations.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: const [
            Text(
              'Finqly values your privacy.\n\n'
              'We do not collect, transmit, or share any personally identifiable information. '
              'All emotional and diagnostic data is stored locally on your device only and never leaves your device.\n\n'
              'You may delete your data at any time by clearing the app storage or using the reset option in settings.\n\n'
              'This policy may be updated from time to time. Please review it regularly.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
