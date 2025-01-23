import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For clipboard functionality
// import 'package:share/share.dart'; // For sharing text
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding and decoding

class ResultScreen extends StatefulWidget {
  final String text;

  const ResultScreen({super.key, required this.text});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

Future<String?> _getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
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

  void saveAsFile() async {
    // Replace this with the actual text you want to save

    const url =
        'http://192.168.27.62:5001/recent-scans'; // Replace with your API endpoint
    final token = await _getToken(); // Retrieve the stored token

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No authentication token found. Please log in again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the token in the header
        },
        body: json.encode({
          'text': displayedText, // Send the text to save
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Scan saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save scan: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
