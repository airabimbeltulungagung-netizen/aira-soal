import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ApkAiraPage extends StatefulWidget {
  const ApkAiraPage({super.key});
  @override
  State<ApkAiraPage> createState() => _ApkAiraPageState();
}

class _ApkAiraPageState extends State<ApkAiraPage> {
  late final WebViewController _controller;
  bool _isLoading =
      true; // Tambahkan loading agar user tahu aplikasinya tidak hang

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) => setState(() => _isLoading = true),
          onPageFinished: (String url) => setState(() => _isLoading = false),
          onWebResourceError: (WebResourceError error) {
            // Ini mencegah aplikasi crash kalau internet mati atau gagal load
            debugPrint("WebView Error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse("https://lynk.id/farhanmahendra"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download APK Aira"),
        backgroundColor: const Color(0xFF1A1530),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFD700)),
            ),
        ],
      ),
    );
  }
}
