import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';

class EscriboEditor extends StatefulWidget {
  // All properties remain unchanged
  final Function(Uint8List imageBytes) onSave;
  final List<TextStyle> fontStyles;
  final List<Color> colorPalette;
  final String initialText;
  final bool dismissKeyboardOnTap;
  final bool validateOnSave;
  final bool Function(String text)? textValidator;
  final VoidCallback? onValidationFail;
  final double aspectRatio;
  final Widget Function(BuildContext context, VoidCallback onClose)?
      closeButtonBuilder;
  final Widget Function(
          BuildContext context, VoidCallback toggleFontSelectorVisibility)?
      fontButtonBuilder;
  final Widget Function(
          BuildContext context, VoidCallback toggleColorPaletteVisibility)?
      colorButtonBuilder;
  final Widget Function(BuildContext context, TextEditingController controller,
      TextStyle currentStyle)? textEditorBuilder;
  final Widget Function(BuildContext context, Color currentColor,
      Function(Color) onColorSelected)? colorPaletteBuilder;
  final Widget Function(
    BuildContext context,
    List<TextStyle> fontStyles,
    TextStyle currentStyle,
    Function(TextStyle) onFontSelected,
  )? fontSelectorBuilder;
  final Widget Function(
    BuildContext context,
    List<Widget> children,
    Color currentColor,
    TextStyle currentStyle,
  )? layoutBuilder;
  final Widget Function(BuildContext context, List<Widget> children)?
      foregroundBuilder;

  const EscriboEditor({
    super.key,
    required this.onSave,
    this.fontStyles = const [],
    this.colorPalette = const [],
    this.initialText = '',
    this.dismissKeyboardOnTap = true,
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
  final ScreenshotController _screenshotController = ScreenshotController();

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
      if (_isColorPaletteVisible) _isFontSelectorVisible = false;
    });
  }

  void _toggleFontSelectorVisibility() {
    setState(() {
      _isFontSelectorVisible = !_isFontSelectorVisible;
      if (_isFontSelectorVisible) _isColorPaletteVisible = false;
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
      canvas, // CRITICAL MODIFICATION: Canvas is now one of the "pieces"
    ];

    return GestureDetector(
      key: const Key('escribo_background_gesture_detector'),
      onTap: _hideOverlays,
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! > 5)
          _hideOverlays();
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
    final canvas = children[7];
    final closeButton = children[0];
    final fontButton = children[1];
    final colorButton = children[2];
    final colorPalette = children[4];
    final saveButton = children[5];
    final fontSelector = children[6];

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
                  fontButton,
                  const SizedBox(width: 16),
                  colorButton
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

  Widget _buildDefaultCloseButton() => IconButton(
      icon: const Icon(Icons.close, color: Colors.white, size: 30),
      onPressed: _onClose);
  Widget _buildDefaultFontButton({required bool isActive}) => Container(
      decoration: isActive
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.25), shape: BoxShape.circle)
          : null,
      child: IconButton(
          icon: const Icon(Icons.text_fields, color: Colors.white, size: 30),
          onPressed: _toggleFontSelectorVisibility));
  Widget _buildDefaultColorButton({required bool isActive}) => Container(
      decoration: isActive
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.25), shape: BoxShape.circle)
          : null,
      child: IconButton(
          icon: const Icon(Icons.palette, color: Colors.white, size: 30),
          onPressed: _toggleColorPaletteVisibility));
  Widget _buildDefaultTextEditor(TextStyle style) => Center(
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
                  hintStyle: TextStyle(color: Colors.white54)))));
  Widget _buildDefaultColorPalette(Color currentColor) => Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  .toList())));
  Widget _buildDefaultFontSelector(TextStyle currentStyle) => Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 10),
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
                                  : Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                              style.fontFamily?.split('_').first ?? 'Font',
                              style: style.copyWith(
                                  color: currentStyle == style
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 20)))))
                  .toList())));
  Widget _buildDefaultSaveButton() => FloatingActionButton(
      onPressed: _save,
      backgroundColor: Colors.white,
      child: const Icon(Icons.check, color: Colors.black, size: 30));
}
