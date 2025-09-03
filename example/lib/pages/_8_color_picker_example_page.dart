import 'package:escribo/escribo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../main.dart';

class ColorPickerExamplePage extends StatefulWidget {
  const ColorPickerExamplePage({super.key});

  @override
  State<ColorPickerExamplePage> createState() => _ColorPickerExamplePageState();
}

class _ColorPickerExamplePageState extends State<ColorPickerExamplePage> {
  // Store color palette in page state to trigger EscriboEditor rebuild
  late List<Color> _palette;

  @override
  void initState() {
    super.initState();
    // Initialize palette with default color
    _palette = [Colors.deepPurple];
  }

  // Open color picker dialog
  void _pickColor(BuildContext context) {
    Color pickerColor = _palette.first; // Current color

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Pick a color'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (color) => pickerColor = color,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Done'),
                onPressed: () {
                  setState(() {
                    // Update palette with new selected color
                    _palette[0] = pickerColor;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EscriboEditor(
      onSave: (imageBytes) {
        showImageSavedDialog(context, imageBytes);
      },
      // Pass state palette to editor - will update when palette changes
      colorPalette: _palette,

      // Replace default color button with custom picker
      colorButtonBuilder: (buttonContext, toggleVisibility) {
        // Ignore default toggleVisibility callback
        return IconButton(
          icon: const Icon(Icons.colorize, color: Colors.white, size: 30),
          tooltip: 'Open Color Picker',
          onPressed: () {
            // Open color picker dialog
            _pickColor(buttonContext);
          },
        );
      },
    );
  }
}
