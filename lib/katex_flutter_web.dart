import 'dart:async';
import 'dart:html';
import 'dart:js' as js;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'katex_flutter.dart';

class KaTeXState extends State<KaTeX> {
  @override
  Widget build(BuildContext context) {
    // Creating a unique identifier for the platform channel
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    Timer(Duration(milliseconds: 250), () {
      js.context.callMethod('katex_flutter_render',[id]);
    });
    ui.platformViewRegistry.registerViewFactory(
        id,
        (int viewID) => SpanElement()
          ..innerHtml = widget.laTeX
          ..classes = ['katex_flutter_code']
          ..id='katex_flutter_$id');
    return (HtmlElementView(
      viewType: id,
    ));
  }
}
