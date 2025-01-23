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
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: _isPermissionGranted
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isLoading ? 80 : 200,
                      height: isLoading ? 80 : 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(isLoading ? 40 : 20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.deepPurple,
                                strokeWidth: 3,
                              ),
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.upload,
                                size: 60,
                                color: Colors.deepPurple.shade400,
                              ),
                              onPressed: _selectImageFromGallery,
                            ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Upload an Image to Scan Text',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.deepPurple.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Supported formats: JPG, PNG',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.deepPurple.shade400,
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.deepPurple.shade400,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Gallery permission denied',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _requestGalleryPermission,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple.shade400,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Grant Permission',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
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
