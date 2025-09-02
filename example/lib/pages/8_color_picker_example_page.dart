import 'package:escribo/escribo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Importa el paquete
import '../main.dart';

class ColorPickerExamplePage extends StatefulWidget {
  const ColorPickerExamplePage({super.key});

  @override
  State<ColorPickerExamplePage> createState() => _ColorPickerExamplePageState();
}

class _ColorPickerExamplePageState extends State<ColorPickerExamplePage> {
  // Guardamos una paleta de colores en el estado de la página.
  // Esto nos permite modificarla y forzar la reconstrucción de EscriboEditor.
  late List<Color> _palette;

  @override
  void initState() {
    super.initState();
    // Inicializamos la paleta con un color por defecto.
    _palette = [Colors.deepPurple];
  }

  // Esta función abrirá el diálogo del selector de color.
  void _pickColor(BuildContext context) {
    Color pickerColor = _palette.first; // El color actual

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
                    // Al presionar "Done", actualizamos nuestra paleta.
                    // Reemplazamos el primer color con el nuevo color seleccionado.
                    // Esto hará que EscriboEditor se reconstruya con el nuevo color disponible.
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
      // Pasamos nuestra paleta de estado al editor.
      // Cuando la paleta cambie, el editor se actualizará.
      colorPalette: _palette,

      // Aquí está la magia: reemplazamos el botón de color por defecto.
      colorButtonBuilder: (buttonContext, toggleVisibility) {
        // Ignoramos el callback `toggleVisibility` porque tenemos nuestro propio sistema.
        return IconButton(
          icon: const Icon(Icons.colorize, color: Colors.white, size: 30),
          tooltip: 'Open Color Picker',
          onPressed: () {
            // Al presionar, llamamos a nuestra función que abre el diálogo.
            _pickColor(buttonContext);
          },
        );
      },
    );
  }
}
