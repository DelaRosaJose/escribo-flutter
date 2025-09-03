import 'package:escribo/escribo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class ThemedExamplePage extends StatelessWidget {
  const ThemedExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Custom "Vaporwave" theme
    final vaporwaveFonts = [
      GoogleFonts.pressStart2p(fontSize: 32, color: Colors.cyanAccent),
      GoogleFonts.majorMonoDisplay(
        fontSize: 48,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      GoogleFonts.pacifico(fontSize: 40, color: Colors.pinkAccent),
    ];

    final vaporwaveColors = [
      const Color(0xFFff71ce),
      const Color(0xFF01cdfe),
      const Color(0xFF05ffa1),
      const Color(0xFFb967ff),
      const Color(0xFFfffb96),
    ];

    return EscriboEditor(
      fontStyles: vaporwaveFonts,
      colorPalette: vaporwaveColors,
      onSave: (imageBytes) {
        showImageSavedDialog(context, imageBytes);
      },
    );
  }
}
