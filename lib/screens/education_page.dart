import 'package:flutter/material.dart';
import 'dart:math';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/theme/colors.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/screens/premium_unlock_page.dart';

class EducationPage extends StatefulWidget {
  final SubscriptionManager subscriptionManager;

  const EducationPage({super.key, required this.subscriptionManager});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage>
    with TickerProviderStateMixin {
  int? flippedIndex;
  bool showExtraTips = false;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    // 表示するTips
    final tips = [
      {
        "title": loc.investmentTips1,
        "detail": "Spread your investments over various asset types. Don’t put all your eggs in one basket.",
        "icon": Icons.pie_chart,
        "color": AppColors.success.withOpacity(0.14),
      },
      {
        "title": loc.investmentTips2,
        "detail": "Short-term emotions can ruin a long-term plan. Stick to your core goals.",
        "icon": Icons.emoji_emotions,
        "color": AppColors.warning.withOpacity(0.14),
      },
      {
        "title": loc.investmentTips3,
        "detail": "Risk is not bad, but it must match your comfort zone. Test yourself first.",
        "icon": Icons.shield,
        "color": AppColors.primary.withOpacity(0.13),
      },
      {
        "title": loc.investmentTips4,
        "detail": "Don’t panic sell. Stay informed but filter the noise.",
        "icon": Icons.info_outline,
        "color": AppColors.accentPurple.withOpacity(0.12),
      },
      {
        "title": loc.investmentTips5,
        "detail": "True investors are patient. Think marathon, not sprint.",
        "icon": Icons.timeline,
        "color": Colors.deepPurpleAccent.withOpacity(0.14),
      },
    ];

    // Premium加入者向けの追加Tips
    final proTips = [
      {
        "title": "💡 Expert Tip: Stay Calm in Volatility",
        "detail": "Market swings are normal. Most successful investors ignore daily fluctuations.",
        "icon": Icons.star,
        "color": Colors.amber.withOpacity(0.15),
      },
      {
        "title": "💡 Expert Tip: Auto-invest",
        "detail": "Setting up monthly auto-investments builds discipline and wealth over time.",
        "icon": Icons.autorenew,
        "color": Colors.greenAccent.withOpacity(0.13),
      },
    ];

    final isPremium = widget.subscriptionManager.isSubscribed;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.tipsTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAF6FF), Color(0xFFEFF6FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
            children: [
              ...List.generate(
                tips.length,
                (i) => _flipCard(
                  context,
                  title: tips[i]["title"]!,
                  detail: tips[i]["detail"]!,
                  icon: tips[i]["icon"] as IconData,
                  color: tips[i]["color"] as Color,
                  flipped: flippedIndex == i,
                  onTap: () => setState(() => flippedIndex = flippedIndex == i ? null : i),
                  isPro: false,
                ),
              ),
              const SizedBox(height: 14),
              // --- Pro限定Tips ---
              if (isPremium && showExtraTips)
                ...List.generate(
                  proTips.length,
                  (i) => _flipCard(
                    context,
                    title: proTips[i]["title"]!,
                    detail: proTips[i]["detail"]!,
                    icon: proTips[i]["icon"] as IconData,
                    color: proTips[i]["color"] as Color,
                    flipped: flippedIndex == 100 + i,
                    onTap: () => setState(() => flippedIndex = flippedIndex == 100 + i ? null : 100 + i),
                    isPro: true,
                  ),
                ),
              // --- Unlockボタン ---
              const SizedBox(height: 24),
              if (!isPremium || !showExtraTips)
                Center(
                  child: ElevatedButton.icon(
                    icon: Icon(isPremium ? Icons.lightbulb : Icons.lock_open),
                    label: Text(isPremium ? "Unlock More Tips" : loc.upgradeToPremium),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPremium ? AppColors.primary : AppColors.accentPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    onPressed: isPremium
                        ? () => setState(() => showExtraTips = true)
                        : () {
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
              if (isPremium && showExtraTips)
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: Center(
                    child: Text(
                      "Enjoy exclusive Pro Tips! 🎉",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // フリップカードUI
  Widget _flipCard(
    BuildContext context, {
    required String title,
    required String detail,
    required IconData icon,
    required Color color,
    required bool flipped,
    required VoidCallback onTap,
    required bool isPro,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 380),
        transitionBuilder: (child, animation) {
          final rotate = Tween(begin: pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotate,
            child: child,
            builder: (context, child) {
              final isUnder = ValueKey(flipped) != child!.key;
              final tilt = (isUnder ? min(rotate.value, pi / 2) : rotate.value);
              return Transform(
                transform: Matrix4.rotationY(tilt),
                alignment: Alignment.center,
                child: child,
              );
            },
          );
        },
        child: flipped
            ? Container(
                key: const ValueKey(true),
                margin: const EdgeInsets.symmetric(vertical: 9),
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.26),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    )
                  ],
                  border: Border.all(color: color.withOpacity(0.22), width: 1.3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPro ? "PRO" : "BASIC",
                      style: TextStyle(
                        color: isPro ? AppColors.accentPurple : AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      detail,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 17.5,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                key: const ValueKey(false),
                margin: const EdgeInsets.symmetric(vertical: 9),
                padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 22),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                  border: Border.all(color: color.withOpacity(0.21)),
                ),
                child: Row(
                  children: [
                    Icon(icon, size: 33, color: AppColors.primary.withOpacity(0.8)),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (isPro)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Icon(Icons.workspace_premium, color: AppColors.accentPurple, size: 22),
                      )
                  ],
                ),
              ),
      ),
    );
  }
}
