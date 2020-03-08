# katex_flutter

Render scientific equations using the KaTeX library.

- **Mathematics / Maths Equations** (Algebra, Calculus, Geometry, Geometry etc...)
- **Physics Equations**
- **Signal Processing Equations**
- **Chemistry Equations**
- **Statistics / Stats Equations**

Rendering is done using **[KaTeX](https://github.com/KaTeX/KaTeX)**.

**katex_flutter** is working on Android, iOS, the Web and the Desktop platform.

On mobile platforms this package mainly depends on [webview_flutter](https://pub.dartlang.org/packages/webview_flutter) plugin. On Android and the web `katex_flutter` fully runs offline.

On web platform this package directly into Flutter's platform view's shadow root.

Unlike flutter_tex it does not create a local web server. This increases the performance significantly and allows non-mobile platforms.

## API

```dart
KaTeX(
  @required laTeX,             // The LaTeX code to be rendered
  delimiter = '\$',            // The delimiter to be used for inline LaTeX
  displayDelimiter = '\$\$',   // The delimiter to be used for Display (centered, "important") LaTeX
  color = Colors.black,        // Background color
  background = Colors.white,   // Text color
  inheritWidth = true,         // Whether to use the parent's width or only the  minimum required by the equation
  onError);                    // Function(String errorMessage) to be executed on Error. Useful for dependency warnings on Desktop.
```

## Use this package as a library

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  katex_flutter: ^3.0.1+18
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

## Platform specific

### Web-only: update `web/index.html`

Add the following code into the `<head>...</head>` section of your `web/index.html`:

```html
<link rel="stylesheet" href="packages/katex_flutter/katex_js/katex.min.css">
<script defer src="packages/katex_flutter/katex_js/katex.min.js"></script>
<script defer src="packages/katex_flutter/katex_js/contrib/auto-render.min.js"></script>
<script src="packages/katex_flutter/katex_flutter.js"></script>
```

In your project, create a `web/packages/katex_flutter` folder.
Now copy `katex_flutter`'s `lib/{katex_flutter.js,katex_js}` into your `web/packages/katex_flutter/`.

### Android-only: update `android/app/src/main/`

**Important:** To use `katex_flutter` on Android you have to copy `example/android/app/src/main/assets` to your project's `android/app/src/main/`.

Due to an issue in the `webview_flutter` plugin you need to add the following to your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.WAKE_LOCK" />
```

The issue is tracked at https://github.com/flutter/flutter/issues/49912

### Desktop

Desktop platforms are supported by native Flutter Desktop as well as go-flutter. You are required to install

 - **[TeX Live](https://www.tug.org/texlive/)** for `pdflatex` command
 - **[ImageMagick](https://imagemagick.org/index.php)** for `convert` command

## Source code

The source code is hosted on [GitLab](https://gitlab.com/testapp-system/katex_flutter). It's licensed under the terms and conditions of the [`EUPL-1.2`](LICENSE).

This package was initially created for the education project **[TestApp](https://gitlab.com/testapp-system/testapp-flutter)**.
