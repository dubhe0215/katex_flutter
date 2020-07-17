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

*Please note: text color is not supported on Desktop fallback. Please use the default rendering library.*