library katex_flutter;

import 'package:catex/catex.dart';
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

  // The delimiter to be used for inline LaTeX
  final String delimiter;

  // The delimiter to be used for Display (centered, "important") LaTeX
  final String displayDelimiter;

  // Deprecated since use of dart-only rendering: Background color
  @deprecated
  final Color background;

  // Deprecated since use of dart-only rendering: Whether to use the parent's
  // width or only the minimum required by the equation
  @deprecated
  final bool inheritWidth;

  // Deprecated since use of dart-only rendering: Function to be executed on
  // error. Useful for Desktop platforms
  @deprecated
  final Function onError;

  // Deprecated since use of dart-only rendering: LaTeX commands to be executed
  // right at the beginning of the document, after last `\usepackage` on Desktop
  // platforms only. May be used to set font face.
  @deprecated
  final String desktopInitString;

  // This option allows you to force the use of the JavaScript KaTeX library
  // instead of the CaTeX dart library for rendering. CaTeX is much faster and
  // offers much better quality as it consists of Dart code only but does not
  // yet support *every* single LaTeX command. Therefore you can specify to use
  // KaTeX as rendering library.
  final bool forceUseOldJavaScriptRendering;

  KaTeX(
      {Key key,
      this.delimiter = r'$',
      this.displayDelimiter = r'$$',
      this.background = Colors.white,
      this.inheritWidth = true,
      this.onError,
      @required this.laTeXCode,
      this.desktopInitString = '\\renewcommand\\familydefault{\\sfdefault}',
      this.forceUseOldJavaScriptRendering = false});

  @override
  State<KaTeX> createState() {
    // Is the user wants to use JS and webviews instead of kind Dart code...
    if (forceUseOldJavaScriptRendering)
      // As different platforms require different implementations we we created a function for choosing
      return chooseStateForPlatform();
    // Otherwise return a native Dart widget
    return CaTeXState();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('desktopInitString', desktopInitString));
  }
}

class CaTeXState extends State<KaTeX> {
  @override
  Widget build(BuildContext context) {
    // Fetching the Widget's LaTeX code as well as it's [TextStyle]
    final String laTeXCode = widget.laTeXCode.data;
    TextStyle defaultTextStyle = widget.laTeXCode.style;

    // Building [RegExp] to find any Math part of the LaTeX code by looking for the specified delimiters
    final String delimiter = widget.delimiter.replaceAll(r'$', r'\$');
    final String displayDelimiter =
        widget.displayDelimiter.replaceAll(r'$', r'\$');

    final String rawRegExp =
        '(($delimiter)([^$delimiter]+)($delimiter)|($displayDelimiter)([^$displayDelimiter]+)($displayDelimiter))';
    List<RegExpMatch> matches =
        RegExp(rawRegExp, dotAll: true).allMatches(laTeXCode).toList();

    // If no single Math part found, returning the raw [Text] from widget.laTeXCode
    if (matches.isEmpty) return widget.laTeXCode;

    // Otherwise looping threw all matches and building a [Wrap] from [Text] and [CaTeX] widgets
    List<Widget> textBlocks = List();
    int lastTextEnd = 0;

    matches.forEach((laTeXMatch) {
      // If there is an offset between the lat match (beginning of the [String] in first case), first adding the found [Text]
      if (laTeXMatch.start > lastTextEnd)
        textBlocks
            .add(Text(laTeXCode.substring(lastTextEnd, laTeXMatch.start)));
      // Adding the [CaTeX] widget to the children
      textBlocks.add(
          CaTeX(laTeXMatch.group(laTeXMatch.group(3) == null ? 6 : 3).trim()));
      lastTextEnd = laTeXMatch.end;
    });

    // If there is any text left after the end of the last match, adding it to children
    if (lastTextEnd < laTeXCode.length) {
      textBlocks.add(Text(laTeXCode.substring(lastTextEnd)));
    }

    // Returning a Wrap containing all the [Text] and [CaTeX] while obeying the specified style in widget.laTeXCode
    return DefaultTextStyle.merge(
      style: defaultTextStyle,
      child: Wrap(
        children: textBlocks,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
      ),
    );
  }
}

String styleString(BuildContext context, Text text) {
  TextStyle style = text.style;
  if (style == null) style = Theme.of(context).textTheme.bodyText1;
  return '''
color: #${style.color.value.toRadixString(16).substring(2).replaceAll('+', '')};
font: ${style.fontSize}px '${style.fontFamily}', sans-serif;''';
}
