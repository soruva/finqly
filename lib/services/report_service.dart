// lib/services/report_service.dart
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmotionEntry {
  final DateTime date;
  final int mood; // 0..5
  EmotionEntry(this.date, this.mood);
}

class ReportService {
  static const _storeKey = 'emotion_history_v1';

  Future<List<EmotionEntry>> last7Days() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_storeKey) ?? <String>[];
    final raw = <EmotionEntry>[];
    for (final s in list) {
      final parts = s.split('|'); // yyyy-MM-dd|mood
      if (parts.length != 2) continue;
      final d = DateTime.tryParse(parts[0]);
      final mood = int.tryParse(parts[1]) ?? 3;
      if (d != null) raw.add(EmotionEntry(d, mood.clamp(0, 5)));
    }
    raw.sort((a, b) => a.date.compareTo(b.date));

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));

    final out = <EmotionEntry>[];
    int? carry;
    for (int i = 0; i < 7; i++) {
      final day = DateTime(start.year, start.month, start.day).add(Duration(days: i));
      final hit = raw.where((e) =>
          e.date.year == day.year && e.date.month == day.month && e.date.day == day.day);
      if (hit.isNotEmpty) {
        carry = hit.last.mood;
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
    final list = prefs.getStringList(_storeKey) ?? <String>[];
    final todayKey = _fmt(DateTime.now());
    final others = list.where((e) => !e.startsWith('$todayKey|')).toList();
    others.add('$todayKey|$mood');
    await prefs.setStringList(_storeKey, others);
  }

  String _fmt(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<XFile> captureToFile(GlobalKey boundaryKey, {String name = 'finqly_weekly.png'}) async {
    final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      throw 'Report boundary not found';
    }
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes, flush: true);
    return XFile(file.path);
  }

  Future<void> shareReport(GlobalKey boundaryKey) async {
    final x = await captureToFile(boundaryKey);
    await Share.shareXFiles([x], text: 'My Finqly weekly report');
  }
}
