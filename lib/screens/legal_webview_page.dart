import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LegalWebViewPage extends StatefulWidget {
  final String title;
  final String assetPath;

  const LegalWebViewPage({
    super.key,
    required this.title,
    required this.assetPath,
  });

  @override
  State<LegalWebViewPage> createState() => _LegalWebViewPageState();
}

class _LegalWebViewPageState extends State<LegalWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..loadFlutterAsset(widget.assetPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: WebViewWidget(controller: _controller),
    );
  }
}
