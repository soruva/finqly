import 'package:flutter/material.dart';
import 'package:finqly/theme/colors.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/services/subscription_manager.dart';

class EducationPage extends StatefulWidget {
  final SubscriptionManager subscriptionManager;
  const EducationPage({super.key, required this.subscriptionManager});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  List<bool> isFlipped = [];

  final List<String> _basicTips = [
    'investmentTips1',
    'investmentTips2',
    'investmentTips3',
  ];

  final List<String> _proTips = [
    'investmentTips1',
    'investmentTips2',
    'investmentTips3',
    'investmentTips4',
    'investmentTips5',
  ];

  @override
  void initState() {
    super.initState();
    isFlipped = List.filled(_proTips.length, false); // 最大数に合わせておく
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return ValueListenableBuilder<bool>(
      valueListenable: widget.subscriptionManager.isSubscribedNotifier,
      builder: (context, isPremium, _) {
        final tipsKeys = isPremium ? _proTips : _basicTips;

        // isFlippedリストの長さ調整
        if (isFlipped.length != tipsKeys.length) {
          isFlipped = List.filled(tipsKeys.length, false);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(loc.investmentTipsTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF4F6FA), Color(0xFFE8DFFC), Color(0xFFB7E3F8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: tipsKeys.length,
                    itemBuilder: (context, index) {
                      final key = tipsKeys[index];
                      final tip = _getTipByKey(loc, key);

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isFlipped[index] = !isFlipped[index];
                            });
                          },
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(scale: animation, child: child),
                            child: isFlipped[index]
                                ? _buildTipCardBack(loc, index)
                                : _buildTipCardFront(tip, index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (!isPremium) ...[
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.lock_open),
                    label: Text(loc.unlockInsights),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      backgroundColor: AppColors.accentPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 2,
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
                  const SizedBox(height: 25),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // 表面：Tips
  Widget _buildTipCardFront(String tip, int idx) {
    return Card(
      key: ValueKey('front$idx'),
      color: AppColors.primary.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tip,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                height: 1.4,
                shadows: [
                  Shadow(color: Colors.black26, blurRadius: 2),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)?.tapToFlip ?? 'Tap to flip',
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  // 裏面：解説（多言語arbに記載したものを取得する形を推奨）
  Widget _buildTipCardBack(AppLocalizations loc, int idx) {
    final explanations = [
      loc.investmentTipsExplanation1,
      loc.investmentTipsExplanation2,
      loc.investmentTipsExplanation3,
      loc.investmentTipsExplanation4,
      loc.investmentTipsExplanation5,
    ];
    return Card(
      key: ValueKey('back$idx'),
      color: Colors.white.withOpacity(0.97),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Center(
          child: Text(
            explanations[idx % explanations.length],
            style: TextStyle(
              fontSize: 17,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              height: 1.6,
              letterSpacing: 0.1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  String _getTipByKey(AppLocalizations loc, String key) {
    switch (key) {
      case 'investmentTips1':
        return loc.investmentTips1;
      case 'investmentTips2':
        return loc.investmentTips2;
      case 'investmentTips3':
        return loc.investmentTips3;
      case 'investmentTips4':
        return loc.investmentTips4;
      case 'investmentTips5':
        return loc.investmentTips5;
      default:
        return '';
    }
  }
}
