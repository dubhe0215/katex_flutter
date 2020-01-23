library katex_flutter;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// The basic WebView for displaying the created HTML String
class KaTeX extends StatefulWidget {
  // The LaTeX code to be rendered
  final String laTeX;

  // The delimiter to be used for inline LaTeX
  final String delimiter;

  // The delimiter to be used for Display (centered, "important") LaTeX
  final String displayDelimiter;

  // Background color
  final Color background;

  // Text color
  final Color color;

  KaTeX(
      {Key key,
      @required this.laTeX,
      this.delimiter = '\$',
      this.displayDelimiter = '\$\$',
      this.color = Colors.black,
      this.background = Colors.white});

  @override
  _KaTeXState createState() => _KaTeXState();
}

class _KaTeXState extends State<KaTeX> {
  WebView _webView;
  String _htmlString;

  // The controller is required to load content from a String

  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();
  WebViewController _controller;

  double _height;
  double _width;

  @override
  void initState() {
    // Waiting for creation of webview
    _controllerCompleter.future.then((webViewController) {
      _controller=webViewController;
      renderLaTeX();
    });
    _webView = WebView(
      debuggingEnabled: false,
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: Set.from([
        JavascriptChannel(
            name: 'RenderedWebViewHeight',
            onMessageReceived: (JavascriptMessage message) {
              // Setting the widget's height to the height posted by JavaScript
              double viewHeight = double.parse(message.message) + 4;
              setState(() {
                _height = viewHeight;
              });
            }),
        JavascriptChannel(
            name: 'RenderedWebViewWidth',
            onMessageReceived: (JavascriptMessage message) {
              // Setting the widget's width to the height posted by JavaScript
              double viewWidth = double.parse(message.message) + 32;
              setState(() {
                _width = viewWidth;
              });
            })
      ]),
      onWebViewCreated: (WebViewController webViewController) {
        if (!_controllerCompleter.isCompleted) _controllerCompleter.complete(webViewController);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_height);
    print(_width);
    print('#${widget.color.value.toRadixString(16).substring(2)}');
    print('#${widget.background.value.toRadixString(16).substring(2)}');
    return SizedBox(
      height: _height,
      width: _width,
      child: _webView,
    );
  }

  @override
  void dispose() {
    _webView = null;
    super.dispose();
  }

  void renderLaTeX({String laTeX}) {
    if(laTeX==null) laTeX=widget.laTeX;
    _htmlString = '''<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.css" integrity="sha384-zB1R0rpPzHqg7Kpt0Aljp8JPLqbXI3bhnPWROx27a9N0Ll6ZP/+DiW/UqRcLbRjq" crossorigin="anonymous">
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.js" integrity="sha384-y23I5Q6l+B6vatafAwxRu/0oK/79VlbSz7Q9aiSZUvyWYIYsd+qj+o24G5ZU2zJz" crossorigin="anonymous"></script>
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/contrib/auto-render.min.js" integrity="sha384-kWPLUVMOks5AQFrykwIup5lo0m3iMkkHrD0uJ4H5cjeGihAutqP0yW0J6dpFiVkI" crossorigin="anonymous"></script>
<script>
  document.addEventListener("DOMContentLoaded", function() {
    renderMathInElement(document.querySelector("#katex_flutter"),{delimiters: [
      {left: "${widget.delimiter}", right: "${widget.delimiter}", display: false},
      {left: "${widget.displayDelimiter}", right: "${widget.displayDelimiter}", display: true}
    ]});
    var height = document.querySelector("#katex_flutter").clientHeight;
    var width = document.querySelector("#katex_flutter").clientWidth;
    RenderedWebViewHeight.postMessage(height);
    RenderedWebViewWidth.postMessage(width);
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
    var localUri = Uri.dataFromString(_htmlString,
        mimeType: 'text/html', encoding: utf8);
    _controller.loadUrl(localUri.toString());
  }
}
