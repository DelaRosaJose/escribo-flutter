import 'package:escribo/escribo.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class AdvancedLayoutPage extends StatefulWidget {
  const AdvancedLayoutPage({super.key});

  @override
  State<AdvancedLayoutPage> createState() => _AdvancedLayoutPageState();
}

class _AdvancedLayoutPageState extends State<AdvancedLayoutPage> {
  double _currentAspectRatio = 1.0;

  final Map<String, double> _aspectRatios = {
    '1:1': 1.0,
    '16:9': 16 / 9,
    '4:5': 4 / 5,
  };

  @override
  Widget build(BuildContext context) {
    return EscriboEditor(
      onSave: (imageBytes) {
        showImageSavedDialog(context, imageBytes);
      },
      aspectRatio: _currentAspectRatio,
      colorPaletteBuilder: (context, currentColor, onColorSelected) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              _getColors(context).map((color) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    onTap: () => onColorSelected(color),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              currentColor == color
                                  ? Colors.white
                                  : Colors.white54,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        );
      },

      fontSelectorBuilder: (context, fontStyles, currentStyle, onFontSelected) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              fontStyles.map((style) {
                final isSelected = currentStyle == style;
                return TextButton(
                  onPressed: () => onFontSelected(style),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        isSelected ? Colors.white : Colors.transparent,
                  ),
                  child: Text(
                    style.fontFamily?.split('_').first ?? 'Font',
                    style: style.copyWith(
                      fontSize: 18,
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  ),
                );
              }).toList(),
        );
      },

      layoutBuilder: (context, children, currentColor, currentStyle) {
        final closeButton = children[0];
        final colorPalette = children[4];
        final saveButton = children[5];
        final fontSelector = children[6];
        final canvas = children[7];

        return Scaffold(
          backgroundColor: const Color(0xFF1a1a2e),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [closeButton, saveButton],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: Center(child: canvas)),
                      Container(
                        width: 120,
                        color: Colors.black.withOpacity(0.2),
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
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                const Text(
                                  'Fonts',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                const Divider(color: Colors.white24),
                                fontSelector,
                                const SizedBox(height: 30),
                                const Text(
                                  'Colors',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                const Divider(color: Colors.white24),
                                colorPalette,
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.black.withOpacity(0.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        _aspectRatios.keys.map((label) {
                          final value = _aspectRatios[label]!;
                          return ChoiceChip(
                            label: Text(label),
                            selectedColor: Colors.teal,
                            selected: _currentAspectRatio == value,
                            onSelected: (isSelected) {
                              if (isSelected)
                                setState(() => _currentAspectRatio = value);
                            },
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Color> _getColors(BuildContext context) {
    return [
      const Color(0xFF25D366),
      const Color(0xFF34B7F1),
      const Color(0xFFE60023),
      const Color(0xFF5851DB),
      const Color(0xFFFFC007),
      const Color(0xFF0A66C2),
    ];
  }
}
