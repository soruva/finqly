import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const String _key = 'emotionHistory';

  /// 直近の履歴をMapリストで返す [{emotion, timestamp}, ...]
  Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    // decode each entry (from JSON string to Map)
    return raw.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  /// 感情を記録（自動でタイムスタンプも保存）
  Future<void> addEntry(String emotion) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];
    final entry = {
      "emotion": emotion,
      "timestamp": DateTime.now().toIso8601String(),
    };
    history.add(jsonEncode(entry));
    await prefs.setStringList(_key, history);
  }

  /// 履歴をクリア
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
