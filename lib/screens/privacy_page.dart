import 'package:flutter/material.dart';
import 'package:finqly/l10n/app_localizations.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {

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
              'We do not collect or share any personally identifiable information. '
              'All emotional and diagnostic data is stored locally on your device only.\n\n'
              'We may use anonymized data for app improvement and analytics. '
              'You may delete your data at any time by clearing the app storage.\n\n'
              'This policy is subject to updates. Please review it regularly.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
