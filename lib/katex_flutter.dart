library katex_flutter;

import 'dart:convert';
import 'dart:html';
import 'dart:js' as js;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
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

  // Whether to use the parent's width or only the minimum required by the equation
  final bool inheritWidth;

  KaTeX(
      {Key key,
      @required this.laTeX,
      this.delimiter = '\$',
      this.displayDelimiter = '\$\$',
      this.color = Colors.black,
      this.background = Colors.white,
      this.inheritWidth = true});

  @override
  _KaTeXState createState() => _KaTeXState();
}

class _KaTeXState extends State<KaTeX> {
  String _htmlString;

  @override
  void initState() {
    generateHTMLCode();
    if (kIsWeb) {
      var _webTeXCode = widget.laTeX.replaceAll(widget.delimiter, '');
      _webTeXCode = _webTeXCode.replaceAll(widget.displayDelimiter, '');
      var htmlCode = js.context['katex'].callMethod("renderToString", [
        _webTeXCode,
        {
          'displayMode': false,
          'output': 'html'
          //'macros': {"\\RR": "\\mathbb{R}"}
        }
      ]);
      //SpanElement katex_span=
      ui.platformViewRegistry.registerViewFactory(
          'iframe',
          (int viewId) => IFrameElement()
            ..classes = ['katex_flutter_code']
            ..style.border = 'none'
            ..src = Uri.dataFromString(
                    '''<html>
<head>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.css" integrity="sha384-zB1R0rpPzHqg7Kpt0Aljp8JPLqbXI3bhnPWROx27a9N0Ll6ZP/+DiW/UqRcLbRjq" crossorigin="anonymous">
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
<body><span id="katex_flutter">''' +
                        htmlCode +
                        '''
</span></body>
</html>''',
                    mimeType: 'text/html',
                    encoding: utf8)
                .toString()
            ..setInnerHtml(
              htmlCode,
            ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Returning native HtmlElementView for Web. Otherwise WebView
    if (kIsWeb) {
      return (HtmlElementView(
        viewType: 'iframe',
      ));
      //return(Text(widget.laTeX));
    } else {
      KaTeXWebView(
        htmlTeX: _htmlString,
        inheritWidth: widget.inheritWidth,
      );
    }
  }

  void generateHTMLCode({String laTeX}) {
    if (laTeX == null) laTeX = widget.laTeX;
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
}

/// The basic WebView for displaying the created HTML String
/// This is currently used for Android and iOS
class KaTeXWebView extends StatefulWidget {
  // The HTML-embedded LaTeX code to be rendered
  final String htmlTeX;

  // Whether to use the parent's width or only the minimum required by the equation
  final bool inheritWidth;

  KaTeXWebView({Key key, @required this.htmlTeX, this.inheritWidth = true});

  @override
  _KaTeXWebViewState createState() => _KaTeXWebViewState();
}

class _KaTeXWebViewState extends State<KaTeXWebView> {
  WebView _webView;

  // The controller is required to load content from a String
  WebViewController _controller;

  double _height = 50;
  double _width;

  @override
  void initState() {
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
            double viewWidth = double.parse(message.message) * 1.2;
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

  void renderLaTeX() {
    var localUri = Uri.dataFromString(widget.htmlTeX,
        mimeType: 'text/html', encoding: utf8);
    _controller.loadUrl(localUri.toString());
  }
}
