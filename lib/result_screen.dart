import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For clipboard functionality
// import 'package:share/share.dart'; // For sharing text

class ResultScreen extends StatefulWidget {
  final String text;

  const ResultScreen({super.key, required this.text});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String displayedText;

  @override
  void initState() {
    super.initState();
    displayedText = widget.text;
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: displayedText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Text copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.deepPurple.shade400,
      ),
    );
  }

  void shareText() {
    // Share.share(displayedText, subject: 'Extracted Text');
  }

  void saveAsFile() {
    // TODO: Implement file-saving functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Save as file feature coming soon!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.deepPurple.shade400,
      ),
    );
  }

  void clearText() {
    setState(() {
      displayedText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Displayed Text Section
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    displayedText.isNotEmpty
                        ? displayedText
                        : 'No text available.',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),

            // Action Buttons Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        onPressed: copyToClipboard,
                        icon: Icons.copy,
                        label: 'Copy',
                        color: Colors.deepPurple,
                      ),
                      _buildActionButton(
                        onPressed: shareText,
                        icon: Icons.share,
                        label: 'Share',
                        color: Colors.purpleAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        onPressed: saveAsFile,
                        icon: Icons.save_alt,
                        label: 'Save',
                        color: Colors.deepPurple,
                      ),
                      _buildActionButton(
                        onPressed: clearText,
                        icon: Icons.clear,
                        label: 'Clear',
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 6,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
      ),
    );
  }
}
