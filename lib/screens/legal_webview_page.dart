import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
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

            final uri = Uri.tryParse(url);
            if (uri == null) {
              return NavigationDecision.prevent;
            }

            const allowed = {'http', 'https', 'mailto', 'tel', 'market', 'geo', 'maps'};

            if (allowed.contains(uri.scheme)) {
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

  Future<void> _reload() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    await _controller.reload();
  }

  Future<void> _handleBack() async {
    final navigator = Navigator.of(context);
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    } else {
      if (!mounted) return;
      navigator.maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    const failedText = 'Failed to load page.';
    const reloadText = 'Reload';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBack,
          ),
        ),
        body: Stack(
          children: [
            if (_hasError)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 36),
                    const SizedBox(height: 12),
                    const Text(
                      failedText,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text(reloadText),
                      onPressed: _reload,
                    ),
                  ],
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
