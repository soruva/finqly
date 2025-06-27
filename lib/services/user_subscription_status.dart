import 'package:shared_preferences/shared_preferences.dart';

class UserSubscriptionStatus {
  static const _key = 'isPremiumUser';

  Future<void> setPremium(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
    print('[Subscription] Premium set to: $value');
  }

  Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }
}
