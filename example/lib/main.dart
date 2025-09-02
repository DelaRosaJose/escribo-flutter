import 'dart:typed_data';
import 'package:flutter/material.dart';

// Importa la página de vista previa
import 'preview_page.dart';

// Importa todas las páginas de ejemplo
import 'pages/1_basic_example_page.dart';
import 'pages/2_themed_example_page.dart';
import 'pages/3_minimalist_layout_page.dart';
import 'pages/4_advanced_layout_page.dart';
import 'pages/5_validation_example_page.dart';
import 'pages/6_branded_editor_page.dart';
import 'pages/7_aspect_ratio_example_page.dart'; // Asegúrate de que esta importación esté presente

void main() {
  runApp(const MyApp());
}

// Navega a una página de vista previa a pantalla completa.
void showImageSavedDialog(BuildContext context, Uint8List imageBytes) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PreviewPage(imageBytes: imageBytes),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escribo Example',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // CORRECCIÓN: La lista de ejemplos ahora incluye las 7 páginas.
    final examples = [
      {
        'title': '1. Basic Example',
        'subtitle': 'Out-of-the-box usage.',
        'page': const BasicExamplePage(),
      },
      {
        'title': '2. Themed Editor',
        'subtitle': 'Custom fonts and colors.',
        'page': const ThemedExamplePage(),
      },
      {
        'title': '3. Minimalist Layout',
        'subtitle': 'Using textEditorBuilder.',
        'page': const MinimalistLayoutPage(),
      },
      {
        'title': '4. Advanced Layout',
        'subtitle': 'Vertical controls & aspect ratio.',
        'page': const AdvancedLayoutPage(),
      },
      {
        'title': '5. Validation Example',
        'subtitle': 'Custom rules before saving.',
        'page': const ValidationExamplePage(),
      },
      {
        'title': '6. Branded Editor',
        'subtitle': 'Adding a watermark/logo.',
        'page': const BrandedEditorPage(),
      },
      {
        'title': '7. Aspect Ratio',
        'subtitle': 'Creating a 9:16 story.',
        'page': const AspectRatioExamplePage(),
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Escribo Examples')),
      body: ListView.builder(
        itemCount: examples.length,
        itemBuilder: (context, index) {
          final example = examples[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              title: Text(
                example['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(example['subtitle'] as String),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.teal,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => example['page'] as Widget,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
