import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:katex_flutter/katex_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter KaTeX Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _laTeXInputController = TextEditingController(text: '''
\$ G_{p,q}^{m,n} \\left(\\begin{matrix}a_1, \\ldots, a_n a_{n+1}, \\ldots, a_p b_1, \\ldots, b_m b_{m+1}, \\ldots, b_q
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
        title: Text('KaTeX Flutter Home Page'),
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
        tooltip: 'Render again. Only working on mobile platform.',
        label: Text('Render LaTeX'),
        icon: Icon(Icons.crop_rotate),
      )
    );
  }

  void _renderLaTeX() {
    setState(() {
      _laTeX = _laTeXInputController.text;
    });
  }
}
