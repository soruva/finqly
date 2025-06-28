import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

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
  late Future<void> _loadingFuture;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    _loadingFuture = _loadHtmlFromAssets();
  }

  Future<void> _loadHtmlFromAssets() async {
    final String fileHtmlContents = await rootBundle.loadString(widget.assetPath);
    await _controller.loadHtmlString(fileHtmlContents);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<void>(
        future: _loadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return WebViewWidget(controller: _controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
