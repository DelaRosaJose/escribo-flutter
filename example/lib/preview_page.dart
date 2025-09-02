import 'dart:typed_data';
import 'package:flutter/material.dart';

class PreviewPage extends StatelessWidget {
  final Uint8List imageBytes;

  const PreviewPage({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Image Preview'),
        // Usamos un botón de cerrar para que la acción sea más clara
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Hacemos pop dos veces para cerrar la vista previa Y el editor,
            // volviendo así a la lista de ejemplos.
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      ),
      // Un fondo oscuro para que la imagen resalte
      backgroundColor: Colors.black87,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // El widget Image.memory es perfecto para mostrar bytes de imagen
          child: Image.memory(imageBytes),
        ),
      ),
    );
  }
}
