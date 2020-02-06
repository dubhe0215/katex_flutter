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

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  katex_flutter: ^2.3.0+14
```
You can install packages from the command line with Flutter:

```shell
flutter pub get
```
Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

Now in your Dart code, you can use:

```dart
import 'package:katex_flutter/katex_flutter.dart';
```

## Web-only: update `web/index.html`

Add the following code into the `<head>...</head>` section of your `web/index.html`:

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.css"
    integrity="sha384-zB1R0rpPzHqg7Kpt0Aljp8JPLqbXI3bhnPWROx27a9N0Ll6ZP/+DiW/UqRcLbRjq" crossorigin="anonymous">
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.js"
    integrity="sha384-y23I5Q6l+B6vatafAwxRu/0oK/79VlbSz7Q9aiSZUvyWYIYsd+qj+o24G5ZU2zJz"
    crossorigin="anonymous"></script>
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/contrib/auto-render.min.js"
    integrity="sha384-kWPLUVMOks5AQFrykwIup5lo0m3iMkkHrD0uJ4H5cjeGihAutqP0yW0J6dpFiVkI"
    crossorigin="anonymous"></script>
<script src="katex_flutter.js"></script>
```
Alternatively you could add the path to a local KaTeX library as well. Note that this will only work on web platform but not on mobile devices.

Then run:
```
flutter pub run katex_flutter:main
```
This will generate the required files in your `web` folder.

If you want to use different LaTeX delimiters than `$` for inline and `$$` for display LaTeX in web, you should modify the `delimiters` section in `web/katex_flutter.js`. In future releases these manual changes will become unneccesairy. We just didn't have enough of time for coding a dynamic implimentation.

## Android-only: update `android/app/src/main/AndroidManifest.xml`

Due to an issue in the `webview_flutter` plugin you need to add the following to your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.WAKE_LOCK" />
```

The issue is tracked at https://github.com/flutter/flutter/issues/49912

## Source code

The source code is hosted on [GitLab](https://gitlab.com/testapp-system/katex_flutter). It's licensed under the terms and conditions of the [`EUPL-1.2`](LICENSE).

This package was initially created for the education project **[TestApp](https://gitlab.com/testapp-system/testapp-flutter)**.
