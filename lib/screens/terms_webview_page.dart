import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsWebViewPage extends StatefulWidget {
  const TermsWebViewPage({super.key});

  @override
  State<TermsWebViewPage> createState() => _TermsWebViewPageState();
}

class _TermsWebViewPageState extends State<TermsWebViewPage> {
  late final WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) => setState(() => _progress = p),
          onNavigationRequest: (request) async {
            final uri = Uri.parse(request.url);

            // Allow local asset
            if (request.url.startsWith('file:///')) {
              return NavigationDecision.navigate;
            }

            // Open external links with url_launcher (http/https/mailto/etc.)
            if (uri.scheme == 'http' ||
                uri.scheme == 'https' ||
                uri.scheme == 'mailto' ||
                uri.scheme == 'tel') {
              final can = await canLaunchUrl(uri);
              if (can) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
                return NavigationDecision.prevent;
              }
            }

            // Default: block unknown schemes
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadFlutterAsset('assets/legal/terms.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: Column(
        children: [
          if (_progress > 0 && _progress < 100)
            LinearProgressIndicator(value: _progress / 100),
          Expanded(child: WebViewWidget(controller: _controller)),
        ],
      ),
    );
  }
}
