import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'katex_flutter.dart';

class KaTeXState extends State<KaTeX> {
  static const String _katexCDN = "https://cdn.jsdelivr.net/npm/katex/dist";
  String _lastKnownLaTeXCode = '';
  WebView _webView;

  // The controller is required to load content from a String
  WebViewController _controller;

  double _height = 50;
  double _width;

  @override
  void initState() {
    _lastKnownLaTeXCode = widget.laTeX;
    Set<JavascriptChannel> jsChannels = Set();
    jsChannels.add(JavascriptChannel(
        name: 'RenderedWebViewHeight',
        onMessageReceived: (JavascriptMessage message) {
          // Setting the widget's height to the height posted by JavaScript
          double viewHeight = double.parse(message.message) * 1.2;
          setState(() {
            _height = viewHeight;
          });
        }));
    if (!widget.inheritWidth)
      jsChannels.add(JavascriptChannel(
          name: 'RenderedWebViewWidth',
          onMessageReceived: (JavascriptMessage message) {
            // Setting the widget's width to the height posted by JavaScript
            double viewWidth = double.parse(message.message) * 1.3;
            setState(() {
              _width = viewWidth;
            });
          }));
    _webView = WebView(
      debuggingEnabled: false,
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: jsChannels,
      onWebViewCreated: (WebViewController webViewController) {
        _controller = webViewController;
        renderLaTeX();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.laTeX != _lastKnownLaTeXCode) renderLaTeX();
    return SizedBox(
      height: _height,
      width: _width,
      child: _webView,
    );
  }

  @override
  void dispose() {
    _webView = null;
    _controller = null;
    super.dispose();
  }

  String generateAppleHTMLCode({String laTeX}) {
    if (laTeX == null) laTeX = widget.laTeX;
    return '''<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<link rel="stylesheet" href="$_katexCDN/katex.min.css">
<script defer src="$_katexCDN/katex.min.js"></script>
<script defer src="$_katexCDN/contrib/auto-render.min.js"></script>
<script>
  document.addEventListener("DOMContentLoaded", function() {
    renderMathInElement(document.querySelector("#katex_flutter"),{delimiters: [
      {left: "${widget.delimiter}", right: "${widget.delimiter}", display: false},
      {left: "${widget.displayDelimiter}", right: "${widget.displayDelimiter}", display: true}
    ]});
    var height = document.querySelector("#katex_flutter").clientHeight;
    var width = document.querySelector("#katex_flutter").clientWidth;
    if("RenderedWebViewHeight" in window) RenderedWebViewHeight.postMessage(height);
    if("RenderedWebViewWidth" in window) RenderedWebViewWidth.postMessage(width);
    });
</script>
<style>
:root {
  color: #${widget.color.value.toRadixString(16).substring(2)}!important;
  background: #${widget.background.value.toRadixString(16).substring(2)}!important;
}
html, body {
  margin: 0;
  padding: 0;
}
body { overflow: auto; }
#katex_flutter {
  display: inline-block;
  width: auto;
  height: auto;
  overflow: auto;
}
</style>
</head>
<body><div id="katex_flutter">${widget.laTeX}</div></body>
</html>''';
  }

  void renderLaTeX() {
    _lastKnownLaTeXCode = widget.laTeX;
    if (Platform.isAndroid) {
      _controller.loadUrl(Uri(
          scheme: 'file',
          host: '',
          path: '/android_asset/katex_flutter.html',
          queryParameters: {
            'laTeX': widget.laTeX,
            'delimiter': widget.delimiter,
            'displayDelimiter': widget.displayDelimiter,
            'color':
                "#${widget.color.value.toRadixString(16).substring(2).replaceAll('+', '')}!important",
            'background':
                "#${widget.background.value.toRadixString(16).substring(2).replaceAll('+', '')}!important",
          }).toString());
    } else {
      var localUri = Uri.dataFromString(generateAppleHTMLCode(),
          mimeType: 'text/html', encoding: utf8);
      _controller.loadUrl(localUri.toString());
    }
  }
}
