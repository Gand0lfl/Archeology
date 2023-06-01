import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class NewsScreen extends StatefulWidget {
  final String url = 'https://m.vk.com/wall-211963181';

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
        onWebViewCreated: (controller) {
          _webViewController = controller;
          _scrollWebView(5); // Scroll by 2 swipes after WebView is created
        },
      ),
    );
  }

  void _scrollWebView(int numSwipes) async {
    if (_webViewController != null) {
      for (int i = 0; i < numSwipes; i++) {
        await _webViewController!.scrollBy(
          x: 0,
          y: 550,
          animated: false,
        );
        await Future.delayed(Duration(milliseconds: 0)); // Delay between each swipe
      }
    }
  }
}
