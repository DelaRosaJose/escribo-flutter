import 'package:escribo/escribo.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class BasicExamplePage extends StatelessWidget {
  const BasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return EscriboEditor(
      onSave: (imageBytes) {
        showImageSavedDialog(context, imageBytes);
      },
    );
  }
}
