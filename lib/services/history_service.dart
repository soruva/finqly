import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to store and retrieve emotion history using SharedPreferences.
///
/// Each entry is stored as a JSON string with fields:
/// - `emotion`: String (user-selected emotion key)
/// - `timestamp`: ISO 8601 String (UTC)
///
/// History is capped at [_maxEntries] (default: 500).
/// Retrieval returns newest-first order.
class HistoryService {
  static const String _key = 'emotionHistory';
  static const int _maxEntries = 500; // default max entries

  /// Returns history entries, newest-first.
  Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? const <String>[];

    final list = <Map<String, dynamic>>[];
    for (final e in raw) {
      try {
        final obj = jsonDecode(e) as Map<String, dynamic>;
        list.add(obj);
      } catch (_) {
        // skip corrupt entry
      }
    }

    list.sort((a, b) {
      final ta = DateTime.tryParse('${a['timestamp']}') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final tb = DateTime.tryParse('${b['timestamp']}') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return tb.compareTo(ta); // newest first
    });

    return list;
  }

  /// Add a new emotion entry with the current timestamp.
  ///
  /// Keeps only the last [_maxEntries] entries (drops oldest).
  Future<void> addEntry(String emotion, {int maxEntries = _maxEntries}) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? <String>[];

    final entry = <String, dynamic>{
      'emotion': emotion,
      'timestamp': DateTime.now().toIso8601String(),
    };

    history.add(jsonEncode(entry));

    // Trim to the last [maxEntries]
    if (history.length > maxEntries) {
      history.removeRange(0, history.length - maxEntries);
    }

    await prefs.setStringList(_key, history);
  }

  /// Clear all history.
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
