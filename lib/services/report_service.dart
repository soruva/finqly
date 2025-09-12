// lib/services/report_service.dart
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmotionEntry {
  final DateTime date;
  final int mood; // 0..5
  const EmotionEntry(this.date, this.mood);
}

class ReportService {
  static const _storeKey = 'emotion_history_v1';

  Future<List<EmotionEntry>> last7Days() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_storeKey) ?? const <String>[];

    final raw = <EmotionEntry>[];
    for (final s in list) {
      final parts = s.split('|'); // yyyy-MM-dd|mood
      if (parts.length != 2) continue;
      final d = DateTime.tryParse(parts[0]);
      final mood = int.tryParse(parts[1]) ?? 3;
      if (d != null) {
        raw.add(EmotionEntry(_atLocalMidnight(d), mood.clamp(0, 5)));
      }
    }
    raw.sort((a, b) => a.date.compareTo(b.date));

    final now = _atLocalMidnight(DateTime.now());
    final start = now.subtract(const Duration(days: 6));

    final out = <EmotionEntry>[];
    int? carry;
    for (int i = 0; i < 7; i++) {
      final day = _atLocalMidnight(start.add(Duration(days: i)));
      final hits = raw.where((e) => _isSameDay(e.date, day));
      if (hits.isNotEmpty) {
        carry = hits.last.mood;
        out.add(EmotionEntry(day, carry));
      } else {
        carry ??= 3;
        out.add(EmotionEntry(day, carry));
      }
    }
    return out;
  }

  Future<void> saveToday(int mood) async {
    final prefs = await SharedPreferences.getInstance();
    final list = List<String>.from(prefs.getStringList(_storeKey) ?? const <String>[]);
    final todayKey = _fmt(DateTime.now());

    list.removeWhere((e) => e.startsWith('$todayKey|'));
    list.add('$todayKey|${mood.clamp(0, 5)}');
    await prefs.setStringList(_storeKey, list);
  }

  Future<ReportSummary> weeklySummary() async {
    final data = await last7Days();
    final avg = data.map((e) => e.mood).fold<int>(0, (a, b) => a + b) / data.length;
    final start = data.first.mood;
    final end = data.last.mood;
    final delta = end - start;
    final best = data.reduce((a, b) => a.mood >= b.mood ? a : b);
    final worst = data.reduce((a, b) => a.mood <= b.mood ? a : b);
    return ReportSummary(
      averageMood: avg,
      deltaFromStart: delta,
      best: best,
      worst: worst,
    );
  }

  Future<XFile> captureToFile(
    GlobalKey boundaryKey, {
    String name = 'finqly_weekly.png',
    double pixelRatio = 3.0,
  }) async {
    final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      throw StateError('Report boundary not found. Ensure RepaintBoundary(key: ...) wraps the widget.');
    }

    final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw StateError('Failed to encode image bytes.');
    }
    final bytes = byteData.buffer.asUint8List();

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes, flush: true);
    return XFile(file.path);
  }

  Future<void> shareReport(GlobalKey boundaryKey) async {
    final x = await captureToFile(boundaryKey);
    await Share.shareXFiles(
      [x],
      text: 'My Finqly weekly report',
      subject: 'Finqly Report',
    );
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storeKey);
  }

  // ---- helpers ----

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  DateTime _atLocalMidnight(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class ReportSummary {
  final double averageMood;
  final int deltaFromStart;
  final EmotionEntry best;
  final EmotionEntry worst;

  const ReportSummary({
    required this.averageMood,
    required this.deltaFromStart,
    required this.best,
    required this.worst,
  });
}
