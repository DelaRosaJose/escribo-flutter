import 'package:escribo/escribo.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class AspectRatioExamplePage extends StatelessWidget {
  const AspectRatioExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example showing how to use aspectRatio for Instagram story format
    return EscriboEditor(
      // Set aspect ratio to 9:16 for vertical story format
      aspectRatio: 9 / 16,
      onSave: (imageBytes) {
        // Navigate to preview page when saving
        showImageSavedDialog(context, imageBytes);
      },
    );
  }
}
