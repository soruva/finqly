import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const String _key = 'emotionHistory';
  static const int _maxEntries = 500; // keep last 500 entries

  /// Returns newest-first.
  Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? const <String>[];

    final list = <Map<String, dynamic>>[];
    for (final e in raw) {
      try {
        final obj = jsonDecode(e);
        if (obj is Map<String, dynamic>) list.add(obj);
      } catch (_) {
        // skip corrupt entry
      }
    }

    // sort by timestamp desc (newest first)
    list.sort((a, b) {
      final ta = DateTime.tryParse('${a['timestamp']}') ?? DateTime.fromMillisecondsSinceEpoch(0);
      final tb = DateTime.tryParse('${b['timestamp']}') ?? DateTime.fromMillisecondsSinceEpoch(0);
      return tb.compareTo(ta);
    });

    return list;
  }

  Future<void> addEntry(String emotion) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? <String>[];

    final entry = <String, dynamic>{
      'emotion': emotion,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // append and trim to max size
    history.add(jsonEncode(entry));
    final overflow = history.length - _maxEntries;
    if (overflow > 0) {
      history.removeRange(0, overflow); // drop oldest
    }

    await prefs.setStringList(_key, history);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
