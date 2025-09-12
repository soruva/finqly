// lib/services/analytics_service.dart
import 'dart:developer' as developer;

class AnalyticsService {
  AnalyticsService._();

  /// - [name]
  /// - [params]
  static void logEvent(String name, [Map<String, dynamic>? params]) {
    final data = params ?? const {};
    developer.log(
      'Analytics event: $name',
      name: 'Analytics',
      error: null,
      sequenceNumber: null,
      level: 800, // INFO
      time: DateTime.now(),
      zone: Zone.current,
      message: data.toString(),
    );
  }

  static void logScreenView(String screenName) {
    logEvent('screen_view', {'screen': screenName});
  }

  static void logPurchase(String productId, double price, String currency) {
    logEvent('purchase', {
      'product_id': productId,
      'price': price,
      'currency': currency,
    });
  }
}
