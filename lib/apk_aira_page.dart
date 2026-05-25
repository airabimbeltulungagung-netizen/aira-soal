import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ApkAiraPage extends StatefulWidget {
  const ApkAiraPage({super.key});
  @override
  State<ApkAiraPage> createState() => _ApkAiraPageState();
}

class _ApkAiraPageState extends State<ApkAiraPage> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://lynk.id/farhanmahendra"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download APK Aira"),
        backgroundColor: const Color(0xFF1A1530),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
