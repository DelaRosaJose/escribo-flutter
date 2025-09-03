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
      // Add watermark that will be captured in the final image
      textEditorBuilder: (context, controller, style) {
        // Stack to place watermark above text field
        return Stack(
          children: [
            // Default text editor behavior
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
            // Watermark that will be captured by Screenshot
            Positioned(
              bottom: 20, // Position within canvas
              right: 20,
              child: Row(
                children: [
                  const FlutterLogo(size: 20), // Smaller size
                  const SizedBox(width: 8),
                  Text(
                    'Powered by Escribo',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
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
