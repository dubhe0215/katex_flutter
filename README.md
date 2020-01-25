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

**Unlike flutter_tex it does not create a local web server. This increases the performance significantly and allows non-mobile platforms.**

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

## Use this package as a library

### 1. Depend on it

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  katex_flutter: ^2.0.1+7
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
    function katex_flutter_render(id) {
        var foundCorrectPlatformView = false;
        // Selecting the correct platform view
        document.querySelectorAll("flt-platform-view").forEach(platformView => {
            var texView = platformView.shadowRoot.children[1];
            if (texView.classList.contains('katex_flutter_code') && texView.id == 'katex_flutter_' + id) {
                // Marking platform view as found
                foundCorrectPlatformView = true;
                // Checking if the LaTeX code was allready rendered by accessing the element's corresponding dataset
                if (texView.dataset['katex_flutter_latex_code'] != undefined) {
                    // If allready rendered, resetting innerHTML
                    texView.innerHTML = texView.dataset['katex_flutter_latex_code'];
                } else {
                    // If not rendered before, saving original code into the element's corresponsing dataset
                    texView.dataset['katex_flutter_latex_code'] = texView.innerHTML;
                }
                // Including CSS into the shadow root
                texView.innerHTML += '<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.css" integrity="sha384-zB1R0rpPzHqg7Kpt0Aljp8JPLqbXI3bhnPWROx27a9N0Ll6ZP/+DiW/UqRcLbRjq" crossorigin="anonymous">';
                // Marking as rendered
                texView.classList.add('katex_fluter_rendered');
                renderMathInElement(texView, {
                    output: 'html',
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
        // Checking if the platform view was found. If not, waiting and trying again...
        if (!foundCorrectPlatformView) {
            setTimeout(() => {
                katex_flutter_render(id)
            }, 500);
            return;
        }
    }
</script>
```

## Source code

The source code is hosted on [GitLab](https://gitlab.com/testapp-system/katex_flutter). It's licensed under the terms and conditions of the [`EUPL-1.2`](LICENSE).

This package was initially created for the education project **[TestApp](https://gitlab.com/testapp-system/testapp-flutter)**.