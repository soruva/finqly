import 'package:flutter/material.dart';
import 'package:finqly/theme/colors.dart';
import 'package:finqly/l10n/app_localizations.dart';
import 'package:finqly/services/history_service.dart';

class EmotionHistoryPage extends StatefulWidget {
  const EmotionHistoryPage({super.key});

  @override
  State<EmotionHistoryPage> createState() => _EmotionHistoryPageState();
}

class _EmotionHistoryPageState extends State<EmotionHistoryPage> {
  List<Map<String, dynamic>> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final list = await HistoryService().getHistory();
    // タイムスタンプ対応の形: [{"emotion": ..., "timestamp": ...}]
    setState(() {
      _entries = list.map<Map<String, dynamic>>((e) {
        try {
          return Map<String, dynamic>.from(jsonDecode(e));
        } catch (_) {
          // レガシー形式対応（文字列のみ記録されていた場合）
          return {
            "emotion": e,
            "timestamp": null,
          };
        }
      }).toList().reversed.toList(); // 新しい順に並べる
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text("Emotion History"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _entries.isEmpty
          ? Center(child: Text(loc.emotionHistoryEmpty))
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              itemCount: _entries.length,
              separatorBuilder: (_, __) => Divider(height: 1),
              itemBuilder: (context, i) {
                final emotion = _entries[i]["emotion"] ?? "";
                final ts = _entries[i]["timestamp"];
                final dateStr = ts != null
                    ? DateTime.fromMillisecondsSinceEpoch(ts)
                        .toLocal()
                        .toString()
                        .replaceFirst(RegExp(r':\d+\.\d+'), '')
                    : '';
                return ListTile(
                  leading: Icon(Icons.emoji_emotions, color: AppColors.primary),
                  title: Text(
                    emotion[0].toUpperCase() + emotion.substring(1),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: dateStr.isNotEmpty
                      ? Text(dateStr, style: const TextStyle(fontSize: 13))
                      : null,
                );
              },
            ),
      floatingActionButton: _entries.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: AppColors.accentPurple,
              foregroundColor: Colors.white,
              child: const Icon(Icons.delete),
              tooltip: "Clear all history",
              onPressed: () async {
                await HistoryService().clearHistory();
                await _loadHistory();
              },
            )
          : null,
    );
  }
}
