import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _isLoading = true;
  bool _hasError = false;

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
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _isLoading = false);
          },
          onWebResourceError: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
          onNavigationRequest: (request) async {
            final url = request.url;

            if (url.startsWith('file:///')) {
              return NavigationDecision.navigate;
            }

            final uri = Uri.parse(url);
            if (uri.scheme == 'http' ||
                uri.scheme == 'https' ||
                uri.scheme == 'mailto' ||
                uri.scheme == 'tel') {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
                return NavigationDecision.prevent;
              }
            }

            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadFlutterAsset(widget.assetPath);
  }

  Future<bool> _handleWillPop() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _controller.canGoBack()) {
                await _controller.goBack();
              } else {
                if (!context.mounted) return;
                Navigator.of(context).maybePop();
              }
            },
          ),
        ),
        body: Stack(
          children: [
            if (_hasError)
              const Center(
                child: Text(
                  'Failed to load page.',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              )
            else
              WebViewWidget(controller: _controller),
            if (_isLoading && !_hasError)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
