import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';

/// A highly customizable and modular widget for creating text-based statuses,
/// inspired by the UI seen in WhatsApp.
///
/// The `EscriboEditor` provides a beautiful default implementation that works
/// out-of-the-box, while also giving developers complete control to override
/// and customize every aspect of the UI through builder functions.
class EscriboEditor extends StatefulWidget {
  /// A callback that gets triggered when the user decides to export the
  /// final creation as an image. The callback receives the image data as a
  /// `Uint8List`.
  final Function(Uint8List imageBytes) onSave;

  /// A list of `TextStyle` objects to cycle through when the font style
  /// button is tapped.
  ///
  /// Defaults to a list of Google Fonts: Roboto, Lobster, and Oswald.
  final List<TextStyle> fontStyles;

  /// A list of `Color` presets to cycle through for the background.
  ///
  /// Defaults to a vibrant list of colors.
  final List<Color> colorPalette;

  /// The placeholder text to show initially.
  ///
  /// Defaults to an empty string `''`.
  final String initialText;

  /// If true, tapping on the background canvas will unfocus the text field
  /// and dismiss the keyboard. Defaults to `true`.
  final bool dismissKeyboardOnTap;

  /// An optional builder function to create a custom close button.
  ///
  /// The provided `onClose` function should be called when the button is tapped.
  final Widget Function(BuildContext context, VoidCallback onClose)?
      closeButtonBuilder;

  /// An optional builder function to create a custom font selection button.
  ///
  /// The provided `toggleFontSelectorVisibility` callback will show/hide the font selector.
  final Widget Function(
          BuildContext context, VoidCallback toggleFontSelectorVisibility)?
      fontButtonBuilder;

  /// An optional builder function to create a custom background color button.
  ///
  /// The provided `toggleColorPaletteVisibility` callback will show/hide the color palette.
  final Widget Function(
          BuildContext context, VoidCallback toggleColorPaletteVisibility)?
      colorButtonBuilder;

  /// An optional builder function for the main text input area.
  ///
  /// This allows for custom display and editing of the text. It provides the
  /// `TextEditingController` and the current `TextStyle`.
  final Widget Function(BuildContext context, TextEditingController controller,
      TextStyle currentStyle)? textEditorBuilder;

  /// An optional builder function to create a custom color palette widget.
  ///
  /// It provides the `currentColor` and a function to call when a new color
  /// is selected.
  final Widget Function(BuildContext context, Color currentColor,
      Function(Color) onColorSelected)? colorPaletteBuilder;

  /// An optional builder to create a custom font selector UI.
  ///
  /// This allows replacing the default horizontal list of font previews.
  /// It provides the list of `fontStyles`, the `currentStyle`, and a callback
  /// `onFontSelected` to be invoked when a user picks a new style.
  final Widget Function(
    BuildContext context,
    List<TextStyle> fontStyles,
    TextStyle currentStyle,
    Function(TextStyle) onFontSelected,
  )? fontSelectorBuilder;

  /// The main layout builder for ultimate customization.
  ///
  /// This function allows developers to define the entire layout of the editor.
  /// It receives a list of the default-built UI components as `children`
  /// (e.g., font button, color button, text area), which can be arranged
  /// as desired or completely replaced.
  final Widget Function(BuildContext context, List<Widget> children)?
      layoutBuilder;

  /// Creates an instance of the EscriboEditor.
  ///
  /// The [onSave] callback is required. All other parameters are optional
  /// and provide customization hooks.
  const EscriboEditor({
    super.key,
    required this.onSave,
    this.fontStyles = const [],
    this.colorPalette = const [],
    this.initialText = '',
    this.dismissKeyboardOnTap = true,
    this.closeButtonBuilder,
    this.fontButtonBuilder,
    this.colorButtonBuilder,
    this.textEditorBuilder,
    this.colorPaletteBuilder,
    this.fontSelectorBuilder,
    this.layoutBuilder,
  });

  @override
  State<EscriboEditor> createState() => _EscriboEditorState();
}

class _EscriboEditorState extends State<EscriboEditor> {
  late final TextEditingController _textController;
  late List<TextStyle> _fontStyles;
  late List<Color> _colorPalette;

  int _currentFontIndex = 0;
  int _currentColorIndex = 0;
  bool _isColorPaletteVisible = false;
  bool _isFontSelectorVisible = false;

  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);

    _fontStyles = widget.fontStyles.isNotEmpty
        ? widget.fontStyles
        : [
            GoogleFonts.roboto(
                fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
            GoogleFonts.lobster(fontSize: 52, color: Colors.white),
            GoogleFonts.oswald(
                fontSize: 48, color: Colors.white, fontWeight: FontWeight.w500),
          ];

    _colorPalette = widget.colorPalette.isNotEmpty
        ? widget.colorPalette
        : [
            const Color(0xFF25D366), // WhatsApp Green
            const Color(0xFF34B7F1), // Twitter Blue
            const Color(0xFFE60023), // Pinterest Red
            const Color(0xFF5851DB), // Discord Purple
            const Color(0xFFFFC007), // Snapchat Yellow
            const Color(0xFF0A66C2), // LinkedIn Blue
          ];
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _toggleColorPaletteVisibility() {
    setState(() {
      _isColorPaletteVisible = !_isColorPaletteVisible;
      if (_isColorPaletteVisible) {
        _isFontSelectorVisible = false; // Ensure mutual exclusivity
      }
    });
  }

  void _toggleFontSelectorVisibility() {
    setState(() {
      _isFontSelectorVisible = !_isFontSelectorVisible;
      if (_isFontSelectorVisible) {
        _isColorPaletteVisible = false; // Ensure mutual exclusivity
      }
    });
  }

  void _onColorSelected(Color color) {
    final index = _colorPalette.indexOf(color);
    if (index != -1) {
      setState(() {
        _currentColorIndex = index;
      });
    }
  }

  void _onFontSelected(TextStyle style) {
    final index = _fontStyles.indexOf(style);
    if (index != -1) {
      setState(() {
        _currentFontIndex = index;
      });
    }
  }

  void _onClose() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _save() {
    // Hide any overlays before taking the screenshot for a clean image
    setState(() {
      _isColorPaletteVisible = false;
      _isFontSelectorVisible = false;
    });

    // Capture the image after the state has been updated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _screenshotController
          .capture(delay: const Duration(milliseconds: 20))
          .then((imageBytes) {
        if (imageBytes != null) {
          widget.onSave(imageBytes);
        }
      });
    });
  }

  void _hideOverlays() {
    if (widget.dismissKeyboardOnTap) {
      FocusScope.of(context).unfocus();
    }
    if (_isColorPaletteVisible || _isFontSelectorVisible) {
      setState(() {
        _isColorPaletteVisible = false;
        _isFontSelectorVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStyle = _fontStyles[_currentFontIndex];
    final currentColor = _colorPalette[_currentColorIndex];

    final closeButton = widget.closeButtonBuilder?.call(context, _onClose) ??
        _buildDefaultCloseButton();

    // MODIFICATION: Pass the active state to the default button builders
    final fontButton = widget.fontButtonBuilder
            ?.call(context, _toggleFontSelectorVisibility) ??
        _buildDefaultFontButton(isActive: _isFontSelectorVisible);
    final colorButton = widget.colorButtonBuilder
            ?.call(context, _toggleColorPaletteVisibility) ??
        _buildDefaultColorButton(isActive: _isColorPaletteVisible);

    final textEditor = widget.textEditorBuilder
            ?.call(context, _textController, currentStyle) ??
        _buildDefaultTextEditor(currentStyle);
    final colorPalette = widget.colorPaletteBuilder
            ?.call(context, currentColor, _onColorSelected) ??
        _buildDefaultColorPalette(currentColor);
    final fontSelector = widget.fontSelectorBuilder
            ?.call(context, _fontStyles, currentStyle, _onFontSelected) ??
        _buildDefaultFontSelector(currentStyle);
    final saveButton = _buildDefaultSaveButton();

    final children = [
      closeButton,
      fontButton,
      colorButton,
      textEditor,
      colorPalette,
      saveButton,
      fontSelector
    ];

    return widget.layoutBuilder?.call(context, children) ??
        _buildDefaultLayout(backgroundColor: currentColor, children: children);
  }

  Widget _buildDefaultLayout(
      {required Color backgroundColor, required List<Widget> children}) {
    const double saveButtonBasePadding = 20.0;
    const double colorPaletteHeight = 50.0;
    const double fontSelectorHeight = 80.0;
    const double fontSelectorMargin = 10.0;

    double saveButtonBottomPadding = saveButtonBasePadding;
    if (_isColorPaletteVisible) {
      saveButtonBottomPadding += colorPaletteHeight;
    } else if (_isFontSelectorVisible) {
      saveButtonBottomPadding += fontSelectorHeight + fontSelectorMargin;
    }

    return Scaffold(
      body: GestureDetector(
        onTap: _hideOverlays,
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta != null && details.primaryDelta! > 5) {
            _hideOverlays();
          }
        },
        child: Screenshot(
          controller: _screenshotController,
          child: Container(
            color: backgroundColor,
            child: Stack(
              children: [
                Positioned.fill(child: children[3]), // textEditor
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      children[0], // closeButton
                      Row(
                        children: [
                          children[1], // fontButton
                          const SizedBox(width: 16),
                          children[2], // colorButton
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      _buildAnimatedSwitcher(
                          child: children[6], // fontSelector
                          isVisible: _isFontSelectorVisible),
                      _buildAnimatedSwitcher(
                          child: children[4], // colorPalette
                          isVisible: _isColorPaletteVisible),
                    ],
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  bottom: saveButtonBottomPadding,
                  right: 16,
                  child: children[5], // saveButton
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSwitcher(
      {required Widget child, required bool isVisible}) {
    return AnimatedSlide(
      offset: isVisible ? Offset.zero : const Offset(0, 2),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: isVisible ? child : null,
      ),
    );
  }

  Widget _buildDefaultCloseButton() => IconButton(
      icon: const Icon(Icons.close, color: Colors.white, size: 30),
      onPressed: _onClose);

  // MODIFICATION: Now accepts an `isActive` parameter to change the style
  Widget _buildDefaultFontButton({required bool isActive}) {
    return Container(
      decoration: isActive
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            )
          : null,
      child: IconButton(
          icon: const Icon(Icons.text_fields, color: Colors.white, size: 30),
          onPressed: _toggleFontSelectorVisibility),
    );
  }

  // MODIFICATION: Now accepts an `isActive` parameter to change the style
  Widget _buildDefaultColorButton({required bool isActive}) {
    return Container(
      decoration: isActive
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            )
          : null,
      child: IconButton(
          icon: const Icon(Icons.palette, color: Colors.white, size: 30),
          onPressed: _toggleColorPaletteVisibility),
    );
  }

  Widget _buildDefaultTextEditor(TextStyle style) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: TextField(
          controller: _textController,
          textAlign: TextAlign.center,
          style: style,
          maxLines: null,
          cursorColor: Colors.white,
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Type a status',
              hintStyle: TextStyle(color: Colors.white54)),
        ),
      ),
    );
  }

  Widget _buildDefaultColorPalette(Color currentColor) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _colorPalette.map((color) {
            return GestureDetector(
              onTap: () => _onColorSelected(color),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: currentColor == color
                          ? Colors.white
                          : Colors.transparent,
                      width: 3),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDefaultFontSelector(TextStyle currentStyle) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(
          bottom: 10), // Add some space between font selector and color palette
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _fontStyles.map((style) {
            return GestureDetector(
              onTap: () => _onFontSelected(style),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: currentStyle == style
                      ? Colors.white
                      : Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  style.fontFamily?.split('_').first ??
                      'Font', // Clean font name
                  style: style.copyWith(
                      color:
                          currentStyle == style ? Colors.black : Colors.white,
                      fontSize: 20),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDefaultSaveButton() {
    return FloatingActionButton(
      onPressed: _save,
      backgroundColor: Colors.white,
      child: const Icon(Icons.check, color: Colors.black, size: 30),
    );
  }
}
