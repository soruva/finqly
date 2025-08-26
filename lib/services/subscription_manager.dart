import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Very thin local cache for "is premium" state.
/// - Purchases are handled elsewhere (IapService).
/// - Call [setSubscribed(true)] only after Play verification.
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

  void dispose() {
    isSubscribedNotifier.dispose();
  }
}
