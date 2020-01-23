# katex_flutter

Render scientific equations using the KaTeX library.

- **Mathematics / Maths Equations** (Algebra, Calculus, Geometry, Geometry etc...)
- **Physics Equations**
- **Signal Processing Equations**
- **Chemistry Equations**
- **Statistics / Stats Equations**

Rendering is done using **[KaTeX](https://github.com/KaTeX/KaTeX)**.

This package mainly depends on [webview_flutter](https://pub.dartlang.org/packages/webview_flutter) plugin.
**Unlike flutter_tex it does not create a local web server. This increases the performance significantly.**

## API

```dart
KaTeX(
  @required laTeX,             // The LaTeX code to be rendered
  delimiter = '\$',            // The delimiter to be used for inline LaTeX
  displayDelimiter = '\$\$',   // The delimiter to be used for Display (centered, "important") LaTeX
  color = Colors.black,        // Background color
  background = Colors.white,   // Text color
  inheritWidth = true);        // Whether to use the parent's width or only the minimum required by the equation
```

## Source code

The source code is hosted on [GitLab](https://gitlab.com/testapp-system/katex_flutter). It's licensed under the terms and conditions of the [`EUPL-1.2`](LICENSE).

This package was initially created for the education project **[TestApp](https://gitlab.com/testapp-system/testapp-flutter)**