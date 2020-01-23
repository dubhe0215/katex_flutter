library katex_flutter;

import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// The basic WebView for displaying the created HTML String
class KaTeX extends StatefulWidget {
  @override
  _KaTeXState createState() => _KaTeXState();

}

class _KaTeXState extends State<KaTeX> {
  WebView _webView=WebView();
  // The controller is required to load content from a String
  WebViewController _controller;

  @override
  void initState() {
    print(_controller);
    _webView.onWebViewCreated(_controller);
    print(_controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _webView;
  }
}