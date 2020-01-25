# katex_flutter

Render scientific equations using the KaTeX library.

- **Mathematics / Maths Equations** (Algebra, Calculus, Geometry, Geometry etc...)
- **Physics Equations**
- **Signal Processing Equations**
- **Chemistry Equations**
- **Statistics / Stats Equations**

Rendering is done using **[KaTeX](https://github.com/KaTeX/KaTeX)**.

**katex_flutter** is working on Android, iOS, and the web platform. Desktop support is planned.

On mobile platofrom this package mainly depends on [webview_flutter](https://pub.dartlang.org/packages/webview_flutter) plugin.

On web platform this package directly into Flutter's platfrom view's shadow root.

**Unlike flutter_tex it does not create a local web server. This increases the performance significantly.**

## API

```dart
Widget KaTeX(
  @required laTeX,             // The LaTeX code to be rendered
  delimiter = '\$',            // The delimiter to be used for inline LaTeX
  displayDelimiter = '\$\$',   // The delimiter to be used for Display (centered, "important") LaTeX
  color = Colors.black,        // Background color
  background = Colors.white,   // Text color
  inheritWidth = true);        // Whether to use the parent's width or only the minimum required by the equation
```

## Use this package as a library

### 1. Depend on it

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  katex_flutter: ^1.0.1+3
```

### 2. Install it

You can install packages from the command line:

with Flutter:

```shell
flutter pub get
```
Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

### 3. Import it

Now in your Dart code, you can use:

```dart
import 'package:katex_flutter/katex_flutter.dart';
```

## Web-only: update `web/index.html`

Add the following code into the `<head>...</head>` section of your `web/index.html`:

If you want to use different LaTeX delimiters than `$` for inline and `$$` for display LaTeX, you should modify the `delimiters` section below. In future releases these manual changes will become unneccesairy. We just didn't have enough of time for coding a dynamic implimentation.

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.css" integrity="sha384-zB1R0rpPzHqg7Kpt0Aljp8JPLqbXI3bhnPWROx27a9N0Ll6ZP/+DiW/UqRcLbRjq" crossorigin="anonymous">
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.js" integrity="sha384-y23I5Q6l+B6vatafAwxRu/0oK/79VlbSz7Q9aiSZUvyWYIYsd+qj+o24G5ZU2zJz" crossorigin="anonymous"></script>
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/contrib/auto-render.min.js" integrity="sha384-kWPLUVMOks5AQFrykwIup5lo0m3iMkkHrD0uJ4H5cjeGihAutqP0yW0J6dpFiVkI" crossorigin="anonymous"></script>
<script>
    function katex_flutter_render() {
        document.querySelectorAll("flt-platform-view").forEach(platformView => {
            if (platformView.shadowRoot.children[1].classList.contains('katex_flutter_code')) {
                renderMathInElement(platformView.shadowRoot.children[1], {
                    delimiters: [{
                        left: "$",
                        right: "$",
                        display: false
                    }, {
                        left: "$$",
                        right: "$$",
                        display: true
                    }]
                })
            }
        })
    }
</script>
```

## Source code

The source code is hosted on [GitLab](https://gitlab.com/testapp-system/katex_flutter). It's licensed under the terms and conditions of the [`EUPL-1.2`](LICENSE).

This package was initially created for the education project **[TestApp](https://gitlab.com/testapp-system/testapp-flutter)**.