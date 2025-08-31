import 'dart:typed_data';
import 'package:flutter/material.dart';
// ¡Importa tu propio paquete!
import 'package:escribo/escribo.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escribo Example',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejemplo de Escribo')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Crear un nuevo estado'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => TextStatusCreator(
                      initialBackgroundColor: Colors.deepPurple,
                      availableFonts: {
                        'Lobster': GoogleFonts.lobster(
                          fontSize: 32,
                          color: Colors.white,
                        ),
                        'Lato': GoogleFonts.lato(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                        'Pacifico': GoogleFonts.pacifico(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                      },
                      onSave: (Uint8List imageBytes) {
                        saveOrDownloadImage(context, imageBytes);
                        Navigator.pop(context);
                      },
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}
