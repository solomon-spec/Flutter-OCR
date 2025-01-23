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
        title: const Text('Extracted Text'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade200, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    displayedText,
                    style:
                        const TextStyle(fontSize: 16, color: Colors.deepPurple),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _buildActionButton(
                  onPressed: copyToClipboard,
                  icon: Icons.copy,
                  label: 'Copy',
                  color: Colors.blue,
                ),
                _buildActionButton(
                  onPressed: shareText,
                  icon: Icons.share,
                  label: 'Share',
                  color: Colors.green,
                ),
                _buildActionButton(
                  onPressed: saveAsFile,
                  icon: Icons.save,
                  label: 'Save',
                  color: Colors.orange,
                ),
                _buildActionButton(
                  onPressed: clearText,
                  icon: Icons.clear,
                  label: 'Clear',
                  color: Colors.red,
                ),
              ],
            ),
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
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        elevation: 5,
        shadowColor: color.withOpacity(0.3),
      ),
    );
  }
}
