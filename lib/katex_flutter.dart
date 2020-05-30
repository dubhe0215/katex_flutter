library katex_flutter;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'katex_flutter_stub.dart'
// ignore: uri_does_not_exist
    if (dart.library.io) 'katex_flutter_io.dart'
// ignore: uri_does_not_exist
    if (dart.library.html) 'katex_flutter_web.dart';

/// The basic WebView for displaying the created HTML String
class KaTeX extends StatefulWidget {
  // a Text used for the rendered code as well as for the style
  final Text laTeXCode;
  // The LaTeX code to be rendered

  @deprecated
  final String laTeX;

  // The delimiter to be used for inline LaTeX
  final String delimiter;

  // The delimiter to be used for Display (centered, "important") LaTeX
  final String displayDelimiter;

  // Background color
  final Color background;

  // Text color
  @deprecated
  final Color color;

  // Whether to use the parent's width or only the minimum required by the equation
  final bool inheritWidth;

  // Function to be executed on error. Useful for Desktop platforms
  final Function onError;

  KaTeX(
      {Key key,
      this.laTeX,
      this.delimiter = '\$',
      this.displayDelimiter = '\$\$',
      this.color,
      this.background = Colors.white,
      this.inheritWidth = true,
      this.onError,
      @required this.laTeXCode});

  @override
  State<KaTeX> createState() {
    // As different platforms require different implementations we we created a function for choosing
    return chooseStateForPlatform();
  }
}

String styleString(BuildContext context, Text text) {
  TextStyle style = text.style;
  if (style == null) style = Theme.of(context).textTheme.bodyText1;
  return '''
color: #${style.color.value.toRadixString(16).substring(2).replaceAll('+', '')};
font: ${style.fontSize}px '${style.fontFamily}', sans-serif;''';
}
