import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class TermsWebViewPage extends StatefulWidget {
  const TermsWebViewPage({super.key});

  @override
  State<TermsWebViewPage> createState() => _TermsWebViewPageState();
}

class _TermsWebViewPageState extends State<TermsWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Android WebView 初期化（必須）
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }

    _controller = WebViewController()
      ..loadFlutterAsset('assets/legal/terms.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
