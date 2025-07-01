import 'package:flutter/material.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/services/subscription_manager.dart'; // 追加
import 'dart:math';

class EducationPage extends StatefulWidget {
  final SubscriptionManager subscriptionManager;

  const EducationPage({super.key, required this.subscriptionManager});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage>
    with TickerProviderStateMixin {
  late List<Map<String, String>> beginnerTips;
  late List<Map<String, String>> proTips;
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    final loc = AppLocalizations.of(context)!;

    beginnerTips = [
      {'icon': '📈', 'text': loc.investmentTips1},
      {'icon': '💡', 'text': loc.investmentTips2},
      {'icon': '📊', 'text': loc.investmentTips3},
    ]..shuffle(Random());

    proTips = [
      {'icon': '🚀', 'text': loc.investmentTips4},
      {'icon': '💰', 'text': loc.investmentTips5},
    ]..shuffle(Random());
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final currentTips = selectedTab == 0 ? beginnerTips : proTips;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.investmentTipsTitle),
        centerTitle: true,
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: TabController(length: 2, vsync: this, initialIndex: selectedTab),
          onTap: (index) => setState(() => selectedTab = index),
          tabs: const [
            Tab(text: 'Beginner'),
            Tab(text: 'Pro'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: currentTips.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final tip = currentTips[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 400 + index * 150),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * 20),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${tip['icon']}  ${tip['text']}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              '⚠️ This content is for general financial education only.\nNo investment advice is provided.',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.lock_open),
              label: const Text('Unlock More Tips'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PremiumUnlockPage(
                      subscriptionManager: widget.subscriptionManager,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
