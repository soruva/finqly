import 'package:flutter/material.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/theme/colors.dart';
import 'package:finqly/services/subscription_manager.dart';

class EducationPage extends StatefulWidget {
  final SubscriptionManager subscriptionManager;

  const EducationPage({super.key, required this.subscriptionManager});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> with SingleTickerProviderStateMixin {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final tips = [
      loc.investmentTips1,
      loc.investmentTips2,
      loc.investmentTips3,
      loc.investmentTips4,
      loc.investmentTips5,
    ];

    final colors = [
      AppColors.accentPurple.withOpacity(0.13),
      AppColors.success.withOpacity(0.11),
      AppColors.warning.withOpacity(0.13),
      AppColors.primary.withOpacity(0.10),
      AppColors.danger.withOpacity(0.11),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.tipsTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F7FD), Color(0xFFEDF4FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 18),
          itemCount: tips.length,
          itemBuilder: (context, idx) {
            final expanded = expandedIndex == idx;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 230),
              curve: Curves.easeOut,
              margin: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: colors[idx % colors.length],
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.14),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  )
                ],
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.09),
                  width: expanded ? 2.2 : 0.5,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(26),
                onTap: () {
                  setState(() => expandedIndex = expanded ? null : idx);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    vertical: expanded ? 34 : 20,
                    horizontal: expanded ? 28 : 20,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: AppColors.accentPurple.withOpacity(0.82),
                        size: expanded ? 34 : 26,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 170),
                          style: TextStyle(
                            fontSize: expanded ? 19 : 16.5,
                            fontWeight: expanded ? FontWeight.bold : FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          child: Text(tips[idx]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
