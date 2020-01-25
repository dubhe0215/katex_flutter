library katex_flutter;

import 'dart:async';
import 'dart:convert';
import 'katex_flutter_stub.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'katex_flutter_mobile.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'katex_flutter_web.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  KaTeXState createState() => KaTeXState();
}
