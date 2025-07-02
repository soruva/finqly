import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LegalWebViewPage extends StatelessWidget {
  final String title;
  final String assetPath;

  const LegalWebViewPage({
    super.key,
    required this.title,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: FutureBuilder<String>(
        future: DefaultAssetBundle.of(context).loadString(assetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Failed to load document.'));
          }
          return WebViewWidget(htmlContent: snapshot.data!);
        },
      ),
    );
  }
}

// WebViewの簡易ラッパー
class WebViewWidget extends StatelessWidget {
  final String htmlContent;

  const WebViewWidget({super.key, required this.htmlContent});

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: Uri.dataFromString(
        htmlContent,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString(),
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
