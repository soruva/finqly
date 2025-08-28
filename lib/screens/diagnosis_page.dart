import 'dart:async';
import 'package:flutter/material.dart';
import 'package:finqly/theme/colors.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/screens/badge_screen.dart';
import 'package:finqly/screens/premium_unlock_page.dart';
import 'package:finqly/services/subscription_manager.dart';
import 'package:finqly/services/history_service.dart';
import 'package:finqly/services/iap_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class DiagnosisPage extends StatefulWidget {
  final SubscriptionManager subscriptionManager;
  const DiagnosisPage({super.key, required this.subscriptionManager});

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  String? selectedEmotionKey;
  bool _busy = false;
  String? _error;

  late final IapService _iap;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  final Map<String, String> _emojis = const {
    'Optimistic': '😊',
    'Neutral': '😐',
    'Worried': '😟',
    'Confused': '😕',
    'Excited': '🤩',
    'Cautious': '🤔',
  };

  @override
  void initState() {
    super.initState();

    _iap = IapService();
    _iap.init();

    _purchaseSub = _iap.purchaseStream.listen((purchases) async {
      for (final p in purchases) {
        try {
          if (p.status == PurchaseStatus.purchased ||
              p.status == PurchaseStatus.restored) {
            if (p.productID == IapService.subscriptionId) {
              await widget.subscriptionManager.setSubscribed(true);
            }

            final key = selectedEmotionKey;
            if (mounted && key != null) {
              setState(() => _busy = false);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BadgeScreen(
                    emotionKey: key,
                    subscriptionManager: widget.subscriptionManager,
                  ),
                ),
              );
            }
          } else if (p.status == PurchaseStatus.error) {
            if (!mounted) continue;
            setState(() {
              _busy = false;
              _error = p.error?.message ?? 'purchase_error';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Purchase error: $_error')),
            );
          }

          if (p.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(p);
          }
        } catch (e) {
          if (!mounted) continue;
          setState(() {
            _busy = false;
            _error = e.toString();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Purchase error: $_error')),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _purchaseSub?.cancel();
    _iap.dispose();
    super.dispose();
  }

  Future<void> _saveEmotionToHistory(String emotion) async {
    await HistoryService().addEntry(emotion);
  }

  Future<void> _showPaywall() async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Unlock options',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text('One-time Diagnosis'),
                subtitle: const Text('\$2.99 • No subscription required'),
                onTap: _busy
                    ? null
                    : () async {
                        Navigator.pop(context);
                        setState(() => _busy = true);
                        await _iap.buyOneTime(IapService.oneTimeDiagnosisId);
                      },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.workspace_premium),
                title: const Text('Go Premium'),
                subtitle: const Text('Monthly or Yearly subscription available'),
                onTap: () {
                  Navigator.pop(context);
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
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final emotionOptions = {
      'Optimistic': loc.optionOptimistic,
      'Neutral': loc.optionNeutral,
      'Worried': loc.optionWorried,
      'Confused': loc.optionConfused,
      'Excited': loc.optionExcited,
      'Cautious': loc.optionCautious,
    };

    return ValueListenableBuilder<bool>(
      valueListenable: widget.subscriptionManager.isSubscribedNotifier,
      builder: (context, isPremiumUser, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              loc.diagnosisTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7B44C6), Color(0xFF72C6EF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        loc.diagnosisQuestion,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 22,
                          letterSpacing: 0.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...emotionOptions.entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: _emotionButton(
                          icon: _emojis[entry.key] ?? '',
                          label: entry.value,
                          onTap: () async {
                            setState(() => selectedEmotionKey = entry.key);
                            await _saveEmotionToHistory(entry.key);
                            if (!mounted) return;

                            if (isPremiumUser) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BadgeScreen(
                                    emotionKey: entry.key,
                                    subscriptionManager: widget.subscriptionManager,
                                  ),
                                ),
                              );
                            } else {
                              await _showPaywall();
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 34),
                    if (!isPremiumUser)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 18, left: 4, right: 4),
                          child: Text(
                            loc.premiumPrompt,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    if (_busy)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: LinearProgressIndicator(minHeight: 2),
                      ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Error: $_error',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _emotionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(1, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 18),
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF462066),
                  letterSpacing: 0.1,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
