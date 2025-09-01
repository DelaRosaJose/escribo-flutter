import 'package:escribo/escribo.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class MinimalistLayoutPage extends StatelessWidget {
  const MinimalistLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EscriboEditor(
      onSave: (imageBytes) {
        showImageSavedDialog(context, imageBytes);
      },
      // This builder completely changes the text input experience.
      textEditorBuilder: (context, controller, style) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your status:',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                style: style,
                maxLines: 3,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.white54,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
