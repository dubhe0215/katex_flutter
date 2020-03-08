import 'dart:io';

import 'package:flutter/widgets.dart';

import 'katex_flutter.dart';
import 'katex_flutter_desktop.dart';
import 'katex_flutter_mobile.dart';
import 'katex_flutter_stub.dart';

State<KaTeX> chooseStateForPlatform() {
  if (Platform.isAndroid || Platform.isIOS) {
    // On Android and iOS, WebViews are supported. Usinf Mobile implimentation
    return KaTeXStateMobile();
  } else if (Platform.isLinux ||
      Platform.isWindows ||
      Platform.isMacOS ||
      Platform.isFuchsia)
    // Using native implimentation on Desktop systems
    return KaTeXStateDesktop();
  else {
    // Fallback for anything else (which actually may not exist)
    return KaTeXStateStub();
  }
}
