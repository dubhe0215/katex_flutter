import 'package:flutter/widgets.dart';

import 'katex_flutter.dart';

class KaTeXStateStub extends State<KaTeX> {
  @override
  Widget build(BuildContext context) {
    print('This platform is not supported.');
    return (Container());
  }
}

State<KaTeX> chooseStateForPlatform() => KaTeXStateStub();