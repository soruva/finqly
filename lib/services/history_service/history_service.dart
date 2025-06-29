import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EmotionEntry {
  final String emotion; // e.g., "Optimistic"
  final DateTime timestamp;

  EmotionEntry({required this.emotion, required this.timestamp});

  Map<String, dynamic> toJson() => {
        'emotion': emotion,
        'timestamp': timestamp.toIso8601String(),
      };

  factory EmotionEntry.fromJson(Map<String, dynamic> json) => EmotionEntry(
        emotion: json['emotion'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

class HistoryService {
  static const String _key = 'emotion_history';

  Future<void> addEmotion(String emotion) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existing = prefs.getStringList(_key) ?? [];

    final entry = EmotionEntry(
      emotion: emotion,
      timestamp: DateTime.now(),
    );

    existing.add(jsonEncode(entry.toJson()));
    await prefs.setStringList(_key, existing);
  }

  Future<List<EmotionEntry>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> stored = prefs.getStringList(_key) ?? [];

    return stored
        .map((e) => EmotionEntry.fromJson(jsonDecode(e)))
        .toList();
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
