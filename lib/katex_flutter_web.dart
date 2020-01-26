import 'dart:async';
import 'dart:html';
import 'dart:js' as js;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'katex_flutter.dart';

class KaTeXState extends State<KaTeX> {
  double _height = 50;
  double _width = 200;
  String platformId;

  @override
  void initState() {
    // Creating a unique identifier for the platform channel
    platformId = DateTime
        .now()
        .microsecondsSinceEpoch
        .toString();
    js.context.callMethod('katex_flutter_render', [platformId]);
    ui.platformViewRegistry.registerViewFactory(
        platformId,
            (int viewID) =>
        SpanElement()
          ..innerHtml = widget.laTeX
          ..classes = ['katex_flutter_code']
        ..id='katex_flutter_$platformId');
    _getDOMboundary(platformId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      _width = double.parse(boundary['width'].replaceFirst('px', '')) * 1.2;
      _height = double.parse(boundary['height'].replaceFirst('px', '')) * 1.2;
    });
  }
}
