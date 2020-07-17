# katex\_flutter

Render scientific LaTeX equations using the KaTeX library.

- **Mathematics / Maths Equations** (Algebra, Calculus, Geometry, Geometry etc...)
- **Physics Equations**
- **Signal Processing Equations**
- **Chemistry Equations**
- **Statistics / Stats Equations**
- **Inherit text style from parent widgets**

*Note: The bad pub.dev score is due to a known error in the analysis server and not our fault.*

LaTeX rendering is done using **[CaTeX](https://pub.dev/packages/catex)** and **[KaTeX](https://github.com/KaTeX/KaTeX)**.

**katex_flutter** is working on Android, iOS, the Web and the Desktop platform.

We are now using native Flutter widgets to render the LaTeX code. This significantly increates the rendering performance
compared to previous versions. For unsupported LaTeX commands, we offer a fallback to the old JavaScript library.

## API

**Note: we recently did significant API changes. Please update any prior code.**
```dart
KaTeX(
  @required laTeXCode,         // A Text() containing the LaTeX code to be rendered
  delimiter = r'$',            // The delimiter to be used for inline LaTeX
  displayDelimiter = r'$$',    // The delimiter to be used for Display (centered, "important") LaTeX
  );
```

## What's the difference to CaTeX library?

Basically, **katex_flutter** is using CaTeX. But as CaTeX is still under development, we
offer a hybrid solution: As long as your LaTeX input is supported by CaTeX, you can profit
from CaTeX' performance but in case CaTeX does not fully support your input, you may fall
back on a slower but more complete LaTeX implementation using JavaScript and the KaTeX library.

Another difference is Text support: CaTeX is simply taking any input for Math rendering.
We split up into Text and Math parts. You can use a separator (eg. the common "$" or "$$").
Content between these separators is rendered as math while anything outside of these separators
is rendered as normal Flutter Text. This makes Text containing only some single formula parts much easier.

## Use this package as a library

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  katex_flutter: ^4.0.0+24
```
You can install packages from the command line with Flutter:

```shell
flutter pub get
```
Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

Now in your Dart code, you can use:

```dart
import 'package:katex_flutter/katex_flutter.dart';

...

// A static LaTeX block which may not change on `setState()`
return KaTeX(laTeXCode: Text("\\alpha", style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.red)))

// A dynamic LaTeX block which is rebuilt on `setState()` (less efficient but required sometimes)
return Builder(builder: (context) => KaTeX(laTeXCode: Text("\\alpha", style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.red))))
```

## Platform specific

***PLEASE NOTE: All the following changes are only required if you use our deprecated fallback library using
JavaScript. Otherwise you do NOT need to perform any of these changes.***

### Web-only: update `web/index.html`

Add the following code into the `<head>...</head>` section of your `web/index.html`:

```html
<link rel="stylesheet" href="/assets/packages/katex_flutter/lib/katex_js/katex.min.css">
<script defer src="/assets/packages/katex_flutter/lib/katex_js/katex.min.js"></script>
<script defer src="/assets/packages/katex_flutter/lib/katex_js/contrib/auto-render.min.js"></script>
<script src="/assets/packages/katex_flutter/lib/katex_flutter.js"></script>
```
### Android-only: update `android/app/src/main/`

Due to an issue in the `webview_flutter` plugin you need to add the following to your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.WAKE_LOCK" />
```

The issue is tracked at https://github.com/flutter/flutter/issues/49912

### Desktop

Desktop platforms are supported by native Flutter Desktop as well as go-flutter but support is not perfectly stable yet. You are required to install

 - **[TeX Live](https://www.tug.org/texlive/)** for `pdflatex` command. (Template `standalone` is required which is delivered by `texlive-most`)
 - **[ImageMagick](https://imagemagick.org/index.php)** for `convert` command

On some Linux distributions, ImageMagick requires an edit of it's policies: Insert the following in `/etc/ImageMagick-7/policy.xml` just before `</policymap>`
```xml
<policy domain="coder" rights="read | write" pattern="PDF" />
```
[Source: Stackoverflow](https://stackoverflow.com/a/53180170/9409389)

*Please note: text color is not yet supported on Desktops.*

## Source code

The source code is hosted on [GitLab](https://gitlab.com/testapp-system/katex_flutter). It's licensed under the terms and conditions of the [`EUPL-1.2`](LICENSE).

This package was initially created for the education project **[TestApp](https://testapp.schule/)**.
