import 'package:shared_preferences/shared_preferences.dart';

/// Local cache for premium flag. Purchase handling is centralized in IapService.
class UserSubscriptionStatus {
  // Align with SubscriptionManager key
  static const String _prefsKey = 'isSubscribed';

  static Future<void> setPremium(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, value);
  }

  static Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKey) ?? false;
  }

  /// No-ops kept for backward compatibility; IapService owns these flows.
  static Future<void> restoreAndSyncPremium() async {/* handled by IapService */}
  static void listenToPurchaseUpdates() {/* handled by IapService */}
}
