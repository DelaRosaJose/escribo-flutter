import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:escribo/escribo.dart';

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
      appBar: AppBar(title: const Text('Escribo Example')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Create a new status'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EscriboEditor(
                  onSave: (Uint8List imageBytes) {
                    // For now, just pop the navigator. 
                    // In a real app, you would save or share the image.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Image saved (simulated)!')),
                    );
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