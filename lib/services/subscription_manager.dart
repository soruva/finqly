import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionManager {
  bool isSubscribed = false;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    isSubscribed = prefs.getBool('isSubscribed') ?? false;
  }

  Future<bool> checkSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isSubscribed') ?? false;
  }

  Future<void> buyPremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSubscribed', true);
    isSubscribed = true;
  }

  Future<void> refreshSubscriptionStatus() async {
    isSubscribed = await checkSubscription();
  }
}
