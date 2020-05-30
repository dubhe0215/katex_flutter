import 'dart:async';
import 'dart:html';
import 'dart:js' as js;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'katex_flutter.dart';

class KaTeXStateWeb extends State<KaTeX> {
  String _lastKnownLaTeXCode = '';
  double _height = 50;
  double _width;
  String platformId;

  @override
  void initState() {
    _createDOMElement();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.laTeXCode.data != _lastKnownLaTeXCode) {
      setState(() {
        _createDOMElement();
      });
    }
    return SizedBox(
      width: _width,
      height: _height,
      child: (HtmlElementView(
        viewType: platformId,
      )),
    );
  }

  // Communication with JavaScript to set the
  void _getDOMboundary(String id) {
    var boundary = js.context.callMethod('katex_flutter_get_boundry', [id]);
    // If the boundary is unknown retrying
    if (boundary == null) {
      Timer(Duration(milliseconds: 250), () {
        _getDOMboundary(id);
      });
      return;
    }
    setState(() {
      _height = double.parse(boundary['height'].replaceFirst('px', '')) * 1.2;
      if (!widget.inheritWidth)
        _width = double.parse(boundary['width'].replaceFirst('px', '')) * 1.3;
    });
  }

  void _createDOMElement() {
    _lastKnownLaTeXCode = widget.laTeXCode.data;
    // Creating a unique identifier for the platform channel
    platformId = DateTime.now().microsecondsSinceEpoch.toString();
    List args = [platformId, styleString(context, widget.laTeXCode)];
    print(args);
    js.context.callMethod('katex_flutter_render', args);
    ui.platformViewRegistry.registerViewFactory(
        platformId,
        (int viewID) => SpanElement()
          ..innerHtml = "<span class=\"katex_flutter_inner_container\">" +
              widget.laTeXCode.data +
              "</span>"
          ..classes = ['katex_flutter_code']
          ..id = 'katex_flutter_$platformId');
    _getDOMboundary(platformId);
  }
}

// No more conditions, returning same state on every
// JS-capable platform
State<KaTeX> chooseStateForPlatform() => KaTeXStateWeb();
