import 'package:escribo/escribo.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class ValidationExamplePage extends StatelessWidget {
  const ValidationExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return EscriboEditor(
      onSave: (imageBytes) {
        showImageSavedDialog(context, imageBytes);
      },
      // Enable validation
      validateOnSave: true,
      // Custom validation rule: text must contain "Escribo"
      textValidator: (text) {
        return text.toLowerCase().contains('escribo');
      },
      // Show feedback when validation fails
      onValidationFail: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'Validation Failed: Status must contain the word "Escribo"!',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
