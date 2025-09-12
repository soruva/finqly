// lib/services/subscription_manager.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finqly/services/iap_service.dart';

/// Very thin local cache for "is premium" state.
/// - Purchases are handled in IapService.
/// - Call [setSubscribed(true)] only after server-side verification in production.
/// - UI can listen via [isSubscribedNotifier].
class SubscriptionManager {
  static const _subscriptionKey = 'isSubscribed';

  /// Reactive premium flag.
  final ValueNotifier<bool> isSubscribedNotifier = ValueNotifier<bool>(false);

  /// Synchronous getter for current value.
  bool get isSubscribed => isSubscribedNotifier.value;

  /// Load cached state on app start.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    isSubscribedNotifier.value = prefs.getBool(_subscriptionKey) ?? false;
  }

  /// Persist & broadcast premium state.
  Future<void> setSubscribed(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_subscriptionKey, value);
    isSubscribedNotifier.value = value;
  }

  /// Reload from disk (no-op if unchanged).
  Future<void> refresh() => init();

  /// Back-compat alias (if older code calls this).
  Future<void> refreshSubscriptionStatus() => refresh();

  /// Clear local state (e.g. on sign-out).
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_subscriptionKey);
    isSubscribedNotifier.value = false;
  }

  /// ✅ Restore purchases end-to-end:
  /// 1) Ask store to restore
  /// 2) Query IapService for active entitlement
  /// 3) Reflect locally (note: in production, prefer server-side verification first)
  Future<bool> restorePurchases() async {
    final restored = await IapService.instance.restorePurchases();
    final active = await IapService.instance.hasActiveSubscription();
    await setSubscribed(active);
    return restored && active;
  }

  void dispose() {
    isSubscribedNotifier.dispose();
  }
}
