import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:katex_flutter/katex_flutter.dart';

// /// If the current platform is a desktop platform that isn't yet supported by
// /// TargetPlatform, override the default platform to one that is.
// /// Otherwise, do nothing.
// void _setTargetPlatformForDesktop() {
//   // No need to handle macOS, as it has now been added to TargetPlatform.
//   if (Platform.isLinux || Platform.isWindows) {
//     debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
//   }
// }

void main() {
  //_setTargetPlatformForDesktop();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter KaTeX Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'KaTeX Flutter Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _laTeXInputController = TextEditingController(text: '''
\$ G_{p,q}^{m,n} \\left(\\begin{matrix}a_1, \\ldots, a_n & a_{n+1}, \\ldots, a_p b_1, \\ldots, b_m & b_{m+1}, \\ldots, b_q
 \\end{matrix} \\bigg| z \\right). \$''');
  String _laTeX;

  @override
  void initState() {
    _renderLaTeX();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                      labelText: 'Your LaTeX code here',
                      helperText:
                          'Use \$ as delimiter. Use \$\$ for display LaTeX.'),
                  controller: _laTeXInputController,
                ),
              ),
              Container(
                child: KaTeX(
                  laTeX: _laTeX,
                  background: Colors.grey[50],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _renderLaTeX,
        tooltip: 'Render again. Not yet implimented for the web.',
        label: Text('Render LaTeX'),
        icon: Icon(Icons.crop_rotate),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _renderLaTeX() {
    setState(() {
      _laTeX = _laTeXInputController.text;
    });
  }
}
