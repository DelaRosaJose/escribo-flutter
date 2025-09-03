import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';

/// A highly customizable text editor for Flutter that allows users to create
/// beautiful and engaging text-based content.
///
/// EscriboEditor provides a rich set of features including:
/// - Text styling (font, color, size, alignment)
/// - Customizable UI components (buttons, toolbars, layout)
/// - Image capture of the editor canvas
/// - Validation and callbacks for user actions
class EscriboEditor extends StatefulWidget {
  /// A callback function that is invoked when the user saves the editor content.
  /// It receives the captured image as a `Uint8List`.
  final Function(Uint8List imageBytes) onSave;

  /// A list of `TextStyle` objects that the user can choose from to style the text.
  /// If empty, a default list of fonts will be provided.
  final List<TextStyle> fontStyles;

  /// A list of `Color` objects that the user can choose from for the background color.
  /// If empty, a default color palette will be provided.
  final List<Color> colorPalette;

  /// The initial text to be displayed in the editor.
  final String initialText;

  /// Whether the keyboard should be dismissed when the user taps outside the text field.
  /// Defaults to `true`.
  final bool dismissKeyboardOnTap;

  /// Whether the keyboard should be dismissed when the user drags on the canvas.
  /// Defaults to `true`.
  final bool dismissKeyboardOnDrag;

  /// Whether to validate the text before saving.
  /// Defaults to `true`.
  final bool validateOnSave;

  /// A callback function to validate the text before saving.
  /// It receives the current text and should return `true` if the text is valid.
  final bool Function(String text)? textValidator;

  /// A callback function that is invoked when the text validation fails.
  final VoidCallback? onValidationFail;

  /// The aspect ratio of the editor canvas.
  /// Defaults to `1.0`.
  final double aspectRatio;

  /// A builder function to create a custom close button.
  final Widget Function(BuildContext context, VoidCallback onClose)?
      closeButtonBuilder;

  /// A builder function to create a custom font button.
  final Widget Function(
          BuildContext context, VoidCallback toggleFontSelectorVisibility)?
      fontButtonBuilder;

  /// A builder function to create a custom color button.
  final Widget Function(
          BuildContext context, VoidCallback toggleColorPaletteVisibility)?
      colorButtonBuilder;

  /// A builder function to create a custom text editor.
  final Widget Function(BuildContext context, TextEditingController controller,
      TextStyle currentStyle)? textEditorBuilder;

  /// A builder function to create a custom color palette.
  final Widget Function(BuildContext context, Color currentColor,
      Function(Color) onColorSelected)? colorPaletteBuilder;

  /// A builder function to create a custom font selector.
  final Widget Function(
    BuildContext context,
    List<TextStyle> fontStyles,
    TextStyle currentStyle,
    Function(TextStyle) onFontSelected,
  )? fontSelectorBuilder;

  /// A builder function to create a custom layout for the editor.
  final Widget Function(
    BuildContext context,
    List<Widget> children,
    Color currentColor,
    TextStyle currentStyle,
  )? layoutBuilder;

  /// A builder function to create a custom foreground layer on top of the editor.
  final Widget Function(BuildContext context, List<Widget> children)?
      foregroundBuilder;

  /// Whether to show a single letter in the font selector instead of the full font name.
  /// Defaults to `false`.
  final bool showSingleLetterInFontSelector;

  /// Whether to enable the font size control.
  /// Defaults to `false`.
  final bool enableFontSizeControl;

  /// Whether to enable the text alignment control.
  /// Defaults to `false`.
  final bool enableTextAlignmentControl;

  /// A list of available font sizes for the font size control.
  /// If empty, a default list of sizes will be provided.
  final List<double>? availableFontSizes;

  /// The minimum font size allowed.
  /// Defaults to `12.0`.
  final double minFontSize;

  /// The maximum font size allowed.
  /// Defaults to `72.0`.
  final double maxFontSize;

  /// A builder function to create a custom font size control.
  final Widget Function(BuildContext context, double currentFontSize,
      Function(double) onFontSizeChanged)? fontSizeControlBuilder;

  /// A builder function to create a custom text alignment control.
  final Widget Function(BuildContext context, TextAlign currentAlignment,
      Function(TextAlign) onAlignmentChanged)? textAlignmentControlBuilder;

  /// A builder function to create a custom font size button.
  final Widget Function(
          BuildContext context, VoidCallback toggleFontSizeControlVisibility)?
      fontSizeButtonBuilder;

  /// A builder function to create a custom text alignment button.
  final Widget Function(BuildContext context,
          VoidCallback toggleTextAlignmentControlVisibility)?
      textAlignButtonBuilder;

  /// The tooltip text for the close button.
  /// Defaults to 'Close'.
  final String closeButtonTooltip;

  /// The tooltip text for the font button.
  /// Defaults to 'Select Font'.
  final String fontButtonTooltip;

  /// The tooltip text for the color button.
  /// Defaults to 'Select Color'.
  final String colorButtonTooltip;

  /// The tooltip text for the font size button.
  /// Defaults to 'Font Size'.
  final String fontSizeButtonTooltip;

  /// The tooltip text for the text alignment button.
  /// Defaults to 'Align Text'.
  final String textAlignButtonTooltip;

  /// The tooltip text for the save button.
  /// Defaults to 'Save'.
  final String saveButtonTooltip;

  const EscriboEditor({
    super.key,
    required this.onSave,
    this.fontStyles = const [],
    this.colorPalette = const [],
    this.initialText = '',
    this.dismissKeyboardOnTap = true,
    this.dismissKeyboardOnDrag = true,
    this.validateOnSave = true,
    this.textValidator,
    this.onValidationFail,
    this.aspectRatio = 1.0,
    this.closeButtonBuilder,
    this.fontButtonBuilder,
    this.colorButtonBuilder,
    this.textEditorBuilder,
    this.colorPaletteBuilder,
    this.fontSelectorBuilder,
    this.layoutBuilder,
    this.foregroundBuilder,
    this.showSingleLetterInFontSelector = false,
    this.enableFontSizeControl = false,
    this.enableTextAlignmentControl = false,
    this.availableFontSizes,
    this.minFontSize = 12.0,
    this.maxFontSize = 72.0,
    this.fontSizeControlBuilder,
    this.textAlignmentControlBuilder,
    this.fontSizeButtonBuilder,
    this.textAlignButtonBuilder,
    this.closeButtonTooltip = 'Close',
    this.fontButtonTooltip = 'Select Font',
    this.colorButtonTooltip = 'Select Color',
    this.fontSizeButtonTooltip = 'Font Size',
    this.textAlignButtonTooltip = 'Align Text',
    this.saveButtonTooltip = 'Save',
  });

  @override
  State<EscriboEditor> createState() => _EscriboEditorState();
}

class _EscriboEditorState extends State<EscriboEditor> {
  // State remains unchanged
  late final TextEditingController _textController;
  late List<TextStyle> _fontStyles;
  late List<Color> _colorPalette;
  int _currentFontIndex = 0;
  int _currentColorIndex = 0;
  bool _isColorPaletteVisible = false;
  bool _isFontSelectorVisible = false;
  bool _isFontSizeControlVisible = false;
  bool _isTextAlignmentControlVisible = false;
  final ScreenshotController _screenshotController = ScreenshotController();

  // New state variables for enhanced functionality
  double _currentFontSize = 48.0;
  TextAlign _currentTextAlign = TextAlign.center;

  // initState, dispose, and other methods remain unchanged
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
            const Color(0xFF25D366),
            const Color(0xFF34B7F1),
            const Color(0xFFE60023),
            const Color(0xFF5851DB),
            const Color(0xFFFFC007),
            const Color(0xFF0A66C2),
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
        _isFontSelectorVisible = false;
        _isFontSizeControlVisible = false;
        _isTextAlignmentControlVisible = false;
      }
    });
  }

  void _toggleFontSelectorVisibility() {
    setState(() {
      _isFontSelectorVisible = !_isFontSelectorVisible;
      if (_isFontSelectorVisible) {
        _isColorPaletteVisible = false;
        _isFontSizeControlVisible = false;
        _isTextAlignmentControlVisible = false;
      }
    });
  }

  void _toggleFontSizeControlVisibility() {
    setState(() {
      _isFontSizeControlVisible = !_isFontSizeControlVisible;
      if (_isFontSizeControlVisible) {
        _isColorPaletteVisible = false;
        _isFontSelectorVisible = false;
        _isTextAlignmentControlVisible = false;
      }
    });
  }

  void _toggleTextAlignmentControlVisibility() {
    setState(() {
      _isTextAlignmentControlVisible = !_isTextAlignmentControlVisible;
      if (_isTextAlignmentControlVisible) {
        _isColorPaletteVisible = false;
        _isFontSelectorVisible = false;
        _isFontSizeControlVisible = false;
      }
    });
  }

  void _onColorSelected(Color color) {
    final index = _colorPalette.indexOf(color);
    if (index != -1) setState(() => _currentColorIndex = index);
  }

  void _onFontSelected(TextStyle style) {
    final index = _fontStyles.indexOf(style);
    if (index != -1) setState(() => _currentFontIndex = index);
  }

  void _onFontSizeChanged(double fontSize) {
    setState(() {
      _currentFontSize = fontSize.clamp(widget.minFontSize, widget.maxFontSize);
    });
  }

  void _onTextAlignmentChanged(TextAlign alignment) {
    setState(() => _currentTextAlign = alignment);
  }

  void _onClose() {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  void _save() {
    if (widget.validateOnSave) {
      final text = _textController.text;
      final isValid =
          widget.textValidator?.call(text) ?? text.trim().isNotEmpty;
      if (!isValid) {
        widget.onValidationFail?.call();
        return;
      }
    }
    _screenshotController.capture().then((imageBytes) {
      if (imageBytes != null) widget.onSave(imageBytes);
    });
  }

  void _hideOverlays() {
    if (widget.dismissKeyboardOnTap) FocusScope.of(context).unfocus();
    if (_isColorPaletteVisible ||
        _isFontSelectorVisible ||
        _isFontSizeControlVisible ||
        _isTextAlignmentControlVisible) {
      setState(() {
        _isColorPaletteVisible = false;
        _isFontSelectorVisible = false;
        _isFontSizeControlVisible = false;
        _isTextAlignmentControlVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = _fontStyles[_currentFontIndex];
    final currentStyle = baseStyle.copyWith(
      fontSize: _currentFontSize,
    );
    final currentColor = _colorPalette[_currentColorIndex];

    final textEditor = widget.textEditorBuilder
            ?.call(context, _textController, currentStyle) ??
        _buildDefaultTextEditor(currentStyle);

    // CRITICAL MODIFICATION: Build canvas here so it's available for all builders
    final canvas = Screenshot(
      controller: _screenshotController,
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Container(color: currentColor, child: textEditor),
      ),
    );

    final children = [
      widget.closeButtonBuilder?.call(context, _onClose) ??
          _buildDefaultCloseButton(),
      widget.fontButtonBuilder?.call(context, _toggleFontSelectorVisibility) ??
          _buildDefaultFontButton(isActive: _isFontSelectorVisible),
      widget.colorButtonBuilder?.call(context, _toggleColorPaletteVisibility) ??
          _buildDefaultColorButton(isActive: _isColorPaletteVisible),
      textEditor, // Raw text editor
      widget.colorPaletteBuilder
              ?.call(context, currentColor, _onColorSelected) ??
          _buildDefaultColorPalette(currentColor),
      _buildDefaultSaveButton(),
      widget.fontSelectorBuilder
              ?.call(context, _fontStyles, currentStyle, _onFontSelected) ??
          _buildDefaultFontSelector(currentStyle),
      // New controls
      widget.enableFontSizeControl
          ? (widget.fontSizeControlBuilder
                  ?.call(context, _currentFontSize, _onFontSizeChanged) ??
              _buildDefaultFontSizeControl())
          : const SizedBox.shrink(),
      widget.enableTextAlignmentControl
          ? (widget.textAlignmentControlBuilder
                  ?.call(context, _currentTextAlign, _onTextAlignmentChanged) ??
              _buildDefaultTextAlignmentControl())
          : const SizedBox.shrink(),
      canvas, // CRITICAL MODIFICATION: Canvas is now one of the "pieces"
      widget.fontSizeButtonBuilder
              ?.call(context, _toggleFontSizeControlVisibility) ??
          _buildDefaultFontSizeButton(isActive: _isFontSizeControlVisible),
      widget.textAlignButtonBuilder
              ?.call(context, _toggleTextAlignmentControlVisibility) ??
          _buildDefaultTextAlignButton(
              isActive: _isTextAlignmentControlVisible),
    ];

    return GestureDetector(
      key: const Key('escribo_background_gesture_detector'),
      onTap: _hideOverlays,
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! > 5) {
          if (widget.dismissKeyboardOnDrag) FocusScope.of(context).unfocus();
          _hideOverlays();
        }
      },
      child: widget.layoutBuilder
              ?.call(context, children, currentColor, currentStyle) ??
          _buildDefaultLayout(
              backgroundColor: currentColor, children: children),
    );
  }

  Widget _buildDefaultLayout(
      {required Color backgroundColor, required List<Widget> children}) {
    // Para mayor claridad, extraemos los widgets de la lista
    final canvas = children[9]; // Canvas is now at index 9
    final closeButton = children[0];
    final fontButton = children[1];
    final colorButton = children[2];
    final colorPalette = children[4];
    final saveButton = children[5];
    final fontSelector = children[6];
    final fontSizeControl = children[7];
    final textAlignmentControl = children[8];
    final fontSizeButton = children[10];
    final textAlignButton = children[11];

    return Scaffold(
      // Ya no es necesario, el layout se gestiona manualmente.
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // El canvas centrado en el fondo
          Center(child: canvas),

          // Controles superiores
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                closeButton,
                Row(children: [
                  if (widget.enableFontSizeControl) ...[
                    fontSizeButton,
                    const SizedBox(width: 16),
                  ],
                  if (widget.enableTextAlignmentControl) ...[
                    textAlignButton,
                    const SizedBox(width: 16),
                  ],
                  fontButton,
                  const SizedBox(width: 16),
                  colorButton,
                ]),
              ],
            ),
          ),

          // SOLUCIÓN: Agrupamos todos los controles inferiores en un solo Positioned
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // La columna ocupa el mínimo espacio
              children: [
                // El selector de fuentes aparecerá aquí
                _buildAnimatedSwitcher(
                    child: fontSelector, isVisible: _isFontSelectorVisible),

                // El selector de colores aparecerá aquí
                _buildAnimatedSwitcher(
                    child: colorPalette, isVisible: _isColorPaletteVisible),

                _buildAnimatedSwitcher(
                    child: fontSizeControl,
                    isVisible: _isFontSizeControlVisible),

                _buildAnimatedSwitcher(
                    child: textAlignmentControl,
                    isVisible: _isTextAlignmentControlVisible),

                // Alineamos el botón de guardado a la derecha
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    // Añadimos padding para que no quede pegado al borde
                    padding: const EdgeInsets.only(
                        right: 16.0, top: 10.0, bottom: 20),
                    child: saveButton,
                  ),
                ),
              ],
            ),
          ),

          if (widget.foregroundBuilder != null)
            widget.foregroundBuilder!(context, children),
        ],
      ),
    );
  }

  // Rest of the _build methods remain unchanged
  Widget _buildAnimatedSwitcher(
      {required Widget child, required bool isVisible}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final slideAnimation =
            Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero)
                .animate(animation);
        return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slideAnimation, child: child));
      },
      child: isVisible ? child : const SizedBox.shrink(),
    );
  }

  Widget _buildDefaultCloseButton() => Tooltip(
      message: widget.closeButtonTooltip,
      child: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 30),
          onPressed: _onClose));

  Widget _buildDefaultFontButton({required bool isActive}) => Tooltip(
      message: widget.fontButtonTooltip,
      child: Container(
          decoration: isActive
              ? BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle)
              : null,
          child: IconButton(
              icon:
                  const Icon(Icons.text_fields, color: Colors.white, size: 30),
              onPressed: _toggleFontSelectorVisibility)));

  Widget _buildDefaultColorButton({required bool isActive}) => Tooltip(
      message: widget.colorButtonTooltip,
      child: Container(
          decoration: isActive
              ? BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle)
              : null,
          child: IconButton(
              icon: const Icon(Icons.palette, color: Colors.white, size: 30),
              onPressed: _toggleColorPaletteVisibility)));

  Widget _buildDefaultFontSizeButton({required bool isActive}) => Tooltip(
      message: widget.fontSizeButtonTooltip,
      child: Container(
          decoration: isActive
              ? BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle)
              : null,
          child: IconButton(
              icon:
                  const Icon(Icons.format_size, color: Colors.white, size: 30),
              onPressed: _toggleFontSizeControlVisibility)));

  Widget _buildDefaultTextAlignButton({required bool isActive}) => Tooltip(
      message: widget.textAlignButtonTooltip,
      child: Container(
          decoration: isActive
              ? BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle)
              : null,
          child: IconButton(
              icon: const Icon(Icons.format_align_center,
                  color: Colors.white, size: 30),
              onPressed: _toggleTextAlignmentControlVisibility)));

  Widget _buildDefaultTextEditor(TextStyle style) => Center(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: TextField(
              controller: _textController,
              textAlign: _currentTextAlign,
              style: style,
              maxLines: null,
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type a status',
                  hintStyle: TextStyle(color: Colors.white54)))));
  Widget _buildDefaultColorPalette(Color currentColor) => Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
          },
        ),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: _colorPalette
                    .map((color) => GestureDetector(
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
                                    width: 3)))))
                    .toList())),
      ));
  Widget _buildDefaultFontSelector(TextStyle currentStyle) => Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 10),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
          },
        ),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: _fontStyles
                    .map((style) => GestureDetector(
                        onTap: () => _onFontSelected(style),
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                                color: currentStyle == style
                                    ? Colors.white
                                    : Colors.black.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                                widget.showSingleLetterInFontSelector
                                    ? (style.fontFamily?.split('_').first.isNotEmpty ==
                                            true
                                        ? style.fontFamily!
                                            .split('_')
                                            .first
                                            .substring(0, 1)
                                            .toUpperCase()
                                        : 'F')
                                    : (style.fontFamily?.split('_').first ??
                                        'Font'),
                                style: style.copyWith(
                                    color: currentStyle == style
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 20)))))
                    .toList())),
      ));
  Widget _buildDefaultSaveButton() => Tooltip(
      message: widget.saveButtonTooltip,
      child: FloatingActionButton(
          onPressed: _save,
          backgroundColor: Colors.white,
          child: const Icon(Icons.check, color: Colors.black, size: 30)));

  Widget _buildDefaultFontSizeControl() {
    final sizes = widget.availableFontSizes ??
        [12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 10),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
          },
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: sizes
                .map((size) => GestureDetector(
                      onTap: () => _onFontSizeChanged(size.toDouble()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: (_currentFontSize - size).abs() < 0.1
                              ? Colors.white
                              : Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${size.toInt()}',
                          style: TextStyle(
                            color: (_currentFontSize - size).abs() < 0.1
                                ? Colors.black
                                : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultTextAlignmentControl() {
    final alignments = [
      {'align': TextAlign.left, 'icon': Icons.format_align_left},
      {'align': TextAlign.center, 'icon': Icons.format_align_center},
      {'align': TextAlign.right, 'icon': Icons.format_align_right},
      {'align': TextAlign.justify, 'icon': Icons.format_align_justify},
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: alignments
            .map((alignment) => GestureDetector(
                  onTap: () =>
                      _onTextAlignmentChanged(alignment['align'] as TextAlign),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: _currentTextAlign == alignment['align']
                          ? Colors.white
                          : Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      alignment['icon'] as IconData,
                      color: _currentTextAlign == alignment['align']
                          ? Colors.black
                          : Colors.white,
                      size: 20,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
