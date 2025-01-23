import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'result_screen.dart';

class TextRecognitionFromGalleryScreen extends StatefulWidget {
  const TextRecognitionFromGalleryScreen({super.key});

  @override
  State<TextRecognitionFromGalleryScreen> createState() =>
      _TextRecognitionFromGalleryScreenState();
}

class _TextRecognitionFromGalleryScreenState
    extends State<TextRecognitionFromGalleryScreen>
    with WidgetsBindingObserver {
  bool _isPermissionGranted = false;
  final textRecognizer = TextRecognizer();
  final ImagePicker _imagePicker = ImagePicker();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _requestGalleryPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload and Scan'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: _isPermissionGranted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: isLoading ? null : _selectImageFromGallery,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLoading)
                          const SizedBox(
                            height: 21,
                            width: 21,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.57,
                            ),
                          ),
                        if (isLoading) const SizedBox(width: 20),
                        const Text(
                          "Upload and Scan",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const Text(
                'Gallery permission denied',
                textAlign: TextAlign.center,
              ),
      ),
    );
  }

  Future<void> _requestGalleryPermission() async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      status = await Permission.photos.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        // For Android 11 and above, request MANAGE_EXTERNAL_STORAGE if necessary
        status = await Permission.manageExternalStorage.request();
      }
    } else {
      // For iOS, request photos permission
      status = await Permission.photos.request();
    }

    setState(() {
      _isPermissionGranted = status == PermissionStatus.granted;
    });

    if (!_isPermissionGranted) {
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
            'Please grant gallery access to select images for text scanning.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectImageFromGallery() async {
    try {
      // Open gallery and let the user pick an image
      final XFile? imageFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (imageFile == null) return; // User canceled the selection

      setState(() {
        isLoading = true;
      });

      // Process the selected image
      final file = File(imageFile.path);
      final inputImage = InputImage.fromFile(file);
      final recognizedText = await textRecognizer.processImage(inputImage);

      // Navigate to the result screen
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(text: recognizedText.text),
        ),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while scanning text')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
