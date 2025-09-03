# Escribo ✍️

[![pub points](https://img.shields.io/pub/points/escribo?style=for-the-badge)](https://pub.dev/packages/escribo/score)
[![pub version](https://img.shields.io/pub/v/escribo.svg?style=for-the-badge)](https://pub.dev/packages/escribo)
[![license](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

A Flutter package to easily create and customize text-based stories or statuses, similar to Instagram or WhatsApp. Choose fonts, backgrounds, and export the result as an image with a polished, ready-to-use UI that is also incredibly flexible.

<br>

<p align="center">
  <video src="https://github.com/user-attachments/assets/963ca75c-ad0d-48ef-bd4d-51064dd5dcec" autoplay loop muted playsinline width="300">
  </video>
</p>

## ✨ Features

- **🎨 Beautiful Out-of-the-Box UI:** A polished, modern editor that works instantly, inspired by the best social apps.
- **🚀 Radically Customizable:** The true power of Escribo. Use builder functions to override a single button or replace the entire layout.
- **📱 Dynamic & Interactive:** Smooth animations for showing/hiding font and color selection panels.
- **👆 Intuitive Gestures:** Tap or drag down to dismiss overlays and the keyboard.
- **🖼️ Configurable Aspect Ratio:** Create square (1:1), widescreen (16:9), or portrait (4:5) images.
- **✅ Built-in Validation:** Prevent users from saving empty statuses and provide custom validation rules.
- **📸 High-Quality Image Export:** Captures the canvas as a `Uint8List`, ready to be saved or shared.
- **🔤 Single Letter Font Display:** Option to show single letters instead of full font names for a cleaner UI.
- **📏 Font Size Control:** Allow users to adjust text size with customizable size ranges and controls.
- **📐 Text Alignment Control:** Enable users to choose text alignment (left, center, right, justify).

## 🚀 Getting Started

### 1. Installation

Add Escribo to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  escribo: ^1.0.0 # Replace with the latest version
```

Then, run `flutter pub get` in your terminal.

### 2. Import the package

```dart
import 'package:escribo/escribo.dart';
```

## 🕹️ Basic Usage

Using Escribo is incredibly simple. The only required parameter is the `onSave` callback.

```dart
import 'package:flutter/material.dart';
import 'package:escribo/escribo.dart';

// ...

void openEditor(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EscriboEditor(
        onSave: (Uint8List imageBytes) {
          // Hide the editor and show a confirmation
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image captured!')),
          );
        },
      ),
    ),
  );
}
```

## 🛠️ Customization Examples

The true power of Escribo lies in its flexibility. You can customize everything using builder functions.

### 1. Themed Editor (Custom Fonts & Colors)

Easily match the editor to your app's theme by providing your own lists of fonts and colors.

```dart
// Make sure to import Google Fonts if you use it
import 'package:google_fonts/google_fonts.dart';

// ...

EscriboEditor(
  onSave: (bytes) => print('Image saved!'),
  fontStyles: [
    GoogleFonts.lato(fontSize: 48, color: Colors.white),
    GoogleFonts.pacifico(fontSize: 42, color: Colors.white),
  ],
  colorPalette: [
    Colors.deepPurple,
    Colors.orangeAccent,
    Colors.red,
  ],
)
```

### 2. Customizing a Single Button

Want to replace the color palette button with one that opens a full color picker? Use `colorButtonBuilder`.

```dart
EscriboEditor(
  onSave: (bytes) => print('Image saved!'),
  colorButtonBuilder: (context, toggleVisibility) {
    // We ignore toggleVisibility and use our own logic
    return IconButton(
      icon: const Icon(Icons.colorize, color: Colors.white),
      onPressed: () {
        // Here you would show your own custom color picker dialog
        print('Open custom color picker!');
      },
    );
  },
)
```

### 3. Adding a Watermark to the Image

Use `textEditorBuilder` to add overlays like a logo that **will be included** in the final image.

```dart
EscriboEditor(
  onSave: (bytes) => print('Image saved!'),
  textEditorBuilder: (context, controller, style) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Replicate the default text editor behavior
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: TextField(
            controller: controller,
            style: style,
            textAlign: TextAlign.center,
            maxLines: null,
            cursorColor: Colors.white,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),

        // Your watermark
        Positioned(
          bottom: 20,
          right: 20,
          child: Text(
            'Powered by My App',
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
          ),
        ),
      ],
    );
  },
)
```

### 4. Total UI Overhaul with `layoutBuilder`

For complete control, use `layoutBuilder` to create a radically different UI. The builder gives you all the pre-built components to arrange as you wish.

```dart
EscriboEditor(
  onSave: (bytes) => print('Image saved!'),
  layoutBuilder: (context, children, currentColor, currentStyle) {
    // The children list gives you access to each pre-built widget by index:
    // 0:close, 1:font, 2:color, 3:textEditor, 4:palette, 5:save, 6:fontSelector, 7:canvas
    final closeButton = children;
    final saveButton = children;
    final canvas = children; // The capture-ready canvas!

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: closeButton,
        actions: [Padding(padding: const EdgeInsets.all(8.0), child: saveButton)],
      ),
      body: Center(
        child: canvas, // Place the capture-ready canvas wherever you want
      ),
    );
  },
)
```

### 5. Enhanced Features: Single Letter Fonts, Font Size & Text Alignment

Escribo now includes advanced text editing features that give users more control over their content.

```dart
EscriboEditor(
  onSave: (bytes) => print('Image saved!'),

  // Show single letters instead of full font names
  showSingleLetterInFontSelector: true,

  // Enable font size control
  enableFontSizeControl: true,
  availableFontSizes: [16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72],
  minFontSize: 16.0,
  maxFontSize: 72.0,

  // Enable text alignment control
  enableTextAlignmentControl: true,

  // Custom font size control (optional)
  fontSizeControlBuilder: (context, currentFontSize, onFontSizeChanged) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text('Font Size: ${currentFontSize.toInt()}',
               style: const TextStyle(color: Colors.white70)),
          Slider(
            value: currentFontSize,
            min: 16.0,
            max: 72.0,
            onChanged: onFontSizeChanged,
          ),
        ],
      ),
    );
  },

  // Custom text alignment control (optional)
  textAlignmentControlBuilder: (context, currentAlignment, onAlignmentChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => onAlignmentChanged(TextAlign.left),
          icon: Icon(Icons.format_align_left,
                     color: currentAlignment == TextAlign.left ? Colors.white : Colors.white54),
        ),
        IconButton(
          onPressed: () => onAlignmentChanged(TextAlign.center),
          icon: Icon(Icons.format_align_center,
                     color: currentAlignment == TextAlign.center ? Colors.white : Colors.white54),
        ),
        IconButton(
          onPressed: () => onAlignmentChanged(TextAlign.right),
          icon: Icon(Icons.format_align_right,
                     color: currentAlignment == TextAlign.right ? Colors.white : Colors.white54),
        ),
        IconButton(
          onPressed: () => onAlignmentChanged(TextAlign.justify),
          icon: Icon(Icons.format_align_justify,
                     color: currentAlignment == TextAlign.justify ? Colors.white : Colors.white54),
        ),
      ],
    );
  },
)
```

## 📚 API Reference

### `EscriboEditor` Parameters

| Parameter                        | Type                                                | Description                                                                                |
| -------------------------------- | --------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| **`onSave` (Required)**          | `Function(Uint8List)`                               | Callback triggered with the image data when the save button is pressed.                    |
| `fontStyles`                     | `List<TextStyle>`                                   | A list of custom `TextStyle` objects for the font selector.                                |
| `showSingleLetterInFontSelector` | `bool`                                              | Show single letters instead of full font names in the font selector. Default: `false`.     |
| `enableFontSizeControl`          | `bool`                                              | Enable font size control for users. Default: `false`.                                      |
| `enableTextAlignmentControl`     | `bool`                                              | Enable text alignment control for users. Default: `false`.                                 |
| `availableFontSizes`             | `List<double>?`                                     | Custom list of available font sizes. If null, uses default range.                          |
| `minFontSize`                    | `double`                                            | Minimum font size allowed. Default: `12.0`.                                                |
| `maxFontSize`                    | `double`                                            | Maximum font size allowed. Default: `72.0`.                                                |
| `colorPalette`                   | `List<Color>`                                       | A list of custom `Color` objects for the color palette.                                    |
| `initialText`                    | `String`                                            | The initial text displayed in the editor. Defaults to `''`.                                |
| `aspectRatio`                    | `double`                                            | The aspect ratio of the final image. Defaults to `1.0` (square).                           |
| `validateOnSave`                 | `bool`                                              | If `true` (default), prevents saving if the text is empty.                                 |
| `textValidator`                  | `bool Function(String)?`                            | A custom function to validate the text before saving.                                      |
| `onValidationFail`               | `VoidCallback?`                                     | A callback triggered if validation fails. Perfect for showing a `SnackBar`.                |
| `dismissKeyboardOnTap`           | `bool`                                              | If `true` (default), tapping the background dismisses the keyboard.                        |
| `closeButtonBuilder`             | `Widget Function(context, onClose)?`                | Builder for a custom close button.                                                         |
| `fontButtonBuilder`              | `Widget Function(context, toggle)?`                 | Builder for a custom font toggle button.                                                   |
| `colorButtonBuilder`             | `Widget Function(context, toggle)?`                 | Builder for a custom color toggle button.                                                  |
| `textEditorBuilder`              | `Widget Function(context, controller, style)?`      | Builder for a custom text editing area. Content inside **is** captured.                    |
| `colorPaletteBuilder`            | `Widget Function(context, color, onSelect)?`        | Builder for a custom color palette widget.                                                 |
| `fontSelectorBuilder`            | `Widget Function(context, fonts, style, onSelect)?` | Builder for a custom font selector widget.                                                 |
| `fontSizeControlBuilder`         | `Widget Function(context, fontSize, onChanged)?`    | Builder for a custom font size control widget.                                             |
| `textAlignmentControlBuilder`    | `Widget Function(context, alignment, onChanged)?`   | Builder for a custom text alignment control widget.                                        |
| `foregroundBuilder`              | `Widget Function(context, children)?`               | Builder to add widgets on top of the default UI. Content **is not** captured in the image. |
| `layoutBuilder`                  | `Widget Function(context, children, color, style)?` | The ultimate builder for a complete UI overhaul. Replaces the entire default layout.       |

## 🤝 Contributing

Contributions are welcome! If you find a bug, have a feature request, or want to improve the code, please feel free to open an issue or submit a pull request.

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
