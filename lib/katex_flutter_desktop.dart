import 'dart:io';

import 'package:flutter/widgets.dart';

import 'katex_flutter.dart';

// State<KaTeX> implimentation using native texbase binaries. Requires
// local [TeX Live](https://www.tug.org/texlive/) and [ImageMagick](https://imagemagick.org/index.php)
//  installation or similar `pdflatex` and `convert` implimentation
class KaTeXStateDesktop extends State<KaTeX> {
  String platformId;
  String currentLaTex;
  bool _texConverted = false;
  File pngFile;

  @override
  void initState() {
    platformId = DateTime.now().microsecondsSinceEpoch.toString();
    currentLaTex = widget.laTeX;
    generatePNG();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (currentLaTex != widget.laTeX) generatePNG();
    return (_texConverted) ? Image.file(pngFile,semanticLabel: currentLaTex,) : Container();
  }

  void generatePNG() async {
    try {
      // Creating new tempdir in filesystem
      var tmpDir = await _generateTmpDir();
      // Converting step by step from LaTeX to PNG
      await Process.run('pdflatex', ['katex.tex'], workingDirectory: tmpDir);
      await Process.run(
          'convert',
          [
            '-colorspace',
            'sRGB',
            '-density',
            '288',
            'katex.pdf',
            '-fuzz',
            '600',
            'katex.png'
          ],
          workingDirectory: tmpDir);

      pngFile = File(tmpDir + '/katex.png');
      _texConverted = true;
      currentLaTex = widget.laTeX;
    } catch (e) {
      widget.onError(e);
    }
    setState(() {});
  }

  Future<String> _generateTmpDir() async {
    // Preparing LaTeX String
    String laTeX = widget.laTeX;
    laTeX = laTeX.replaceAll(RegExp('<\\s*[bB][rR](\\s|\\/)*>'), '\\\\*');
    // Determinating the correct TMP path
    String path =
        (Platform.isWindows ? '%TEMP%' : '/tmp') + '/katex_flutter/$platformId';
    // Creating sub folder
    await Directory(path).create(recursive: true);
    // Populating the input TeX file
    RandomAccessFile texFileAccess =
        await File(path + '/katex.tex').open(mode: FileMode.write);
    texFileAccess.writeStringSync('''
\\documentclass[preview]{standalone}
\\begin{document}
$laTeX
\\end{document}
''');
    texFileAccess.flushSync();
    // Returning the empdir location
    return (path);
  }
}
