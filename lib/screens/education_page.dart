import 'package:flutter/material.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/services/user_subscription_status.dart';
import 'dart:math';

class EducationPage extends StatefulWidget {
  final SubscriptionManager subscriptionManager;

  const EducationPage({super.key, required this.subscriptionManager});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> with TickerProviderStateMixin {
  late TabController _tabController;
  int selectedTab = 0;
  bool isPremium = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: selectedTab);
    _tabController.addListener(() {
      if (_tabController.index != selectedTab) {
        setState(() => selectedTab = _tabController.index);
      }
    });
    _checkPremiumStatus();
  }

  Future<void> _checkPremiumStatus() async {
    final premium = await UserSubscriptionStatus().isPremium();
    setState(() => isPremium = premium);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, String>> _getBeginnerTips(AppLocalizations loc) {
    return [
      {'icon': '📈', 'text': loc.investmentTips1},
      {'icon': '💡', 'text': loc.investmentTips2},
      {'icon': '📊', 'text': loc.investmentTips3},
    ]..shuffle(Random());
  }

  List<Map<String, String>> _getProTips(AppLocalizations loc) {
    return [
      {'icon': '🚀', 'text': loc.investmentTips4},
      {'icon': '💰', 'text': loc.investmentTips5},
    ]..shuffle(Random());
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final beginnerTips = _getBeginnerTips(loc);
    final proTips = _getProTips(loc);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.investmentTipsTitle),
        centerTitle: true,
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Beginner'),
            Tab(text: 'Pro'),
          ],
        ),
      ),
      body: selectedTab == 1 && !isPremium
          ? _buildProLocked(context, loc)
          : _buildTipsList(selectedTab == 0 ? beginnerTips : proTips, loc),
    );
  }

  Widget _buildTipsList(List<Map<String, String>> tips, AppLocalizations loc) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: tips.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final tip = tips[index];
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
    );
  }

  Widget _buildProLocked(BuildContext context, AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 72, color: Colors.grey),
          const SizedBox(height: 18),
          Text(
            "Unlock Pro Tips with Premium!",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            icon: const Icon(Icons.workspace_premium),
            label: Text(loc.unlockInsights),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
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
        ],
      ),
    );
  }
}
