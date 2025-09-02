import 'package:escribo/escribo.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class BrandedEditorPage extends StatelessWidget {
  const BrandedEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EscriboEditor(
      onSave: (imageBytes) {
        showImageSavedDialog(context, imageBytes);
      },
      // MODIFICACIÓN: Para añadir una marca de agua que SÍ sea parte de la
      // imagen final, debemos usar un builder que renderice DENTRO de la
      // zona de captura. `textEditorBuilder` es el lugar perfecto para esto.
      textEditorBuilder: (context, controller, style) {
        // Usamos un Stack para colocar la marca de agua encima del campo de texto.
        return Stack(
          children: [
            // Primero, replicamos el comportamiento del editor de texto por defecto
            // para que el usuario pueda seguir escribiendo normalmente.
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  style: style,
                  maxLines: null,
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type a status',
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
            ),
            // Después, añadimos nuestra marca de agua encima, que ahora
            // SÍ será capturada por el Screenshot.
            Positioned(
              bottom: 20, // Posiciónalo dentro del canvas
              right: 20,
              child: Row(
                children: [
                  const FlutterLogo(size: 20), // Un poco más pequeño
                  const SizedBox(width: 8),
                  Text(
                    'Powered by Escribo',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
