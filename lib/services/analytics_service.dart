// lib/services/analytics_service.dart
class AnalyticsService {
  static void logEvent(String name, [Map<String, dynamic>? params]) {
    // ignore: avoid_print
    print('[Analytics] $name ${params ?? {}}');
  }
}
