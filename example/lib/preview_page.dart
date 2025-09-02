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
        // Use close button to make action clearer
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // returning to preview
            Navigator.of(context).pop();
          },
        ),
      ),
      // Dark background to make image stand out
      backgroundColor: Colors.black87,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // Image.memory widget is perfect for displaying image bytes
          child: Image.memory(imageBytes),
        ),
      ),
    );
  }
}
