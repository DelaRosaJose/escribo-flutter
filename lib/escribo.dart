import 'dart:async';
import 'package:escribo/escribo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:download/download.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

export 'src/escribo_fonts.dart';

/// A comprehensive widget for creating, customizing, and saving text-based image statuses.
class TextStatusCreator extends StatefulWidget {
  /// A callback that triggers when the user saves the image.
  /// It provides the generated image data as a `Uint8List`.
  final Function(Uint8List imageBytes) onSave;

  /// A map of font styles available to the user.
  /// The key is the display name for the font (e.g., 'Modern'), and the value is the TextStyle.
  final Map<String, TextStyle> availableFonts;

  /// The initial background color of the canvas.
  final Color initialBackgroundColor;

  const TextStatusCreator({
    super.key,
    required this.onSave,
    this.availableFonts = const {},
    this.initialBackgroundColor = Colors.blueGrey,
  });

  @override
  State<TextStatusCreator> createState() => _TextStatusCreatorState();
}

class _TextStatusCreatorState extends State<TextStatusCreator> {
  final _screenshotController = ScreenshotController();

  // Internal UI state for the editor
  String _text = 'Type something here...';
  late Color _backgroundColor;
  late TextStyle _currentTextStyle;
  late Map<String, TextStyle> _finalFonts;

  @override
  void initState() {
    super.initState();
    _backgroundColor = widget.initialBackgroundColor;

    // Provide default fonts if the developer does not supply any.
    _finalFonts = widget.availableFonts.isEmpty
        ? kEscriboDefaultFonts
        : widget.availableFonts;
    _currentTextStyle = _finalFonts.values.first;
  }

  /// Captures the canvas widget as an image and triggers the [onSave] callback.
  void _captureAndSave() async {
    final imageBytes = await _screenshotController.capture(
      delay: const Duration(milliseconds: 20),
    );
    if (imageBytes != null) {
      widget.onSave(imageBytes);
    }
  }

  /// Shows a dialog with a color picker to let the user change the background color.
  void _pickBackgroundColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose a background color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _backgroundColor,
            onColorChanged: (color) => setState(() => _backgroundColor = color),
          ),
        ),
        actions: [
          ElevatedButton(
            child: const Text('Done'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// Builds the visual canvas area that will be captured as an image.
  Widget _buildCanvas() {
    return Screenshot(
      controller: _screenshotController,
      child: Container(
        height: 400,
        width: double.infinity,
        color: _backgroundColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _text,
              textAlign: TextAlign.center,
              style: _currentTextStyle,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Save',
            onPressed: _captureAndSave,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCanvas(),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => setState(() =>
                  _text = value.isNotEmpty ? value : 'Type something here...'),
              decoration: const InputDecoration(
                labelText: 'Your Text',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<TextStyle>(
              value: _currentTextStyle,
              decoration: const InputDecoration(
                labelText: 'Font Style',
                border: OutlineInputBorder(),
              ),
              items: _finalFonts.entries.map((entry) {
                return DropdownMenuItem<TextStyle>(
                  value: entry.value,
                  child: Text(entry.key,
                      style: entry.value
                          .copyWith(color: Colors.black, fontSize: 18)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _currentTextStyle = value);
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.color_lens),
              label: const Text('Change Background Color'),
              onPressed: _pickBackgroundColor,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A helper function to be used by the app developer.
/// Saves the image to the gallery on mobile or triggers a download on web.
Future<void> saveOrDownloadImage(
    BuildContext context, Uint8List imageBytes) async {
  // kIsWeb is a global Flutter constant that is `true` if the app is running on the web.
  if (kIsWeb) {
    // Web logic: Download the file.
    try {
      final stream = Stream.fromIterable(imageBytes);
      await download(stream,
          'escribo_status_${DateTime.now().millisecondsSinceEpoch}.png');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Downloading image...')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading image: $e')),
      );
    }
  } else {
    // Mobile logic (Android/iOS): Save to the gallery.
    final result = await ImageGallerySaver.saveImage(imageBytes,
        name: "escribo_status_${DateTime.now().millisecondsSinceEpoch}");
    if (result['isSuccess']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image saved to gallery!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save image.')),
      );
    }
  }
}
