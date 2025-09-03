import 'package:escribo/escribo.dart';
import 'package:flutter/material.dart';

class EmbeddedEditorExamplePage extends StatefulWidget {
  const EmbeddedEditorExamplePage({super.key});

  @override
  State<EmbeddedEditorExamplePage> createState() =>
      _EmbeddedEditorExamplePageState();
}

class _EmbeddedEditorExamplePageState extends State<EmbeddedEditorExamplePage> {
  // Boolean to control editor visibility
  bool _isEditorVisible = false;

  // Widget to show when editor is hidden
  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Create a visual status',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // Widget to build the editor
  Widget _buildEditor() {
    return EscriboEditor(
      onSave: (imageBytes) {
        // Hide editor and show feedback when saving
        setState(() => _isEditorVisible = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.teal,
            content: Text('Status saved successfully! (Simulated)'),
          ),
        );
      },
      // Override close button to control this page's state
      closeButtonBuilder: (context, onClose) {
        // Ignore default onClose and use our own setState
        return IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => setState(() => _isEditorVisible = false),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Embedded Editor')),
      // Gradient background for styling
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE0F2F1), Color(0xFFB2DFDB)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Container with specific size to house the editor
                Container(
                  height: 500, // Fixed height
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  // ClipRRect ensures editor respects rounded corners
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    // AnimatedSwitcher for smooth transition
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      // Show placeholder or editor based on state
                      child:
                          _isEditorVisible
                              ? _buildEditor()
                              : _buildPlaceholder(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Button that controls visibility
                ElevatedButton.icon(
                  icon: Icon(
                    _isEditorVisible ? Icons.visibility_off : Icons.add,
                  ),
                  label: Text(
                    _isEditorVisible ? 'Hide Editor' : 'Create Status',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isEditorVisible ? Colors.grey : Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _isEditorVisible = !_isEditorVisible;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
