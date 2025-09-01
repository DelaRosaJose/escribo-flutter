import 'package:escribo/escribo.dart';
import 'package:flutter/material.dart';
import '../main.dart'; // Para usar la función de vista previa de imagen

class AspectRatioExamplePage extends StatelessWidget {
  const AspectRatioExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Este ejemplo muestra cómo usar la propiedad `aspectRatio` para crear
    // un canvas con una proporción específica, como la de una historia de Instagram.
    return EscriboEditor(
      // Establecemos el aspect ratio a 9:16 para un formato vertical de historia.
      aspectRatio: 9 / 16,
      onSave: (imageBytes) {
        // Al guardar, navegamos a la página de vista previa.
        showImageSavedDialog(context, imageBytes);
      },
    );
  }
}
