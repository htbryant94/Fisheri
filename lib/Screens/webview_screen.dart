// @dart=2.9

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class WebViewExplorer extends StatefulWidget {
  WebViewExplorer({this.url});

  final String url;

  @override
  _WebViewExplorerState createState() => _WebViewExplorerState();
}

class _WebViewExplorerState extends State<WebViewExplorer> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.url,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}