// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'result_screen.dart';

// class TextRecognitionFromCamera extends StatefulWidget {
//   const TextRecognitionFromCamera({super.key});

//   @override
//   State<TextRecognitionFromCamera> createState() => _TextRecognitionFromCameraState();
// }

// class _TextRecognitionFromCameraState extends State<TextRecognitionFromCamera> with WidgetsBindingObserver {
//   bool _isPermissionGranted = false;

//   late final Future<void> _future;
//   CameraController? _cameraController;

//   final textRecognizer = TextRecognizer();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);

//     _future = _requestCameraPermission();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _stopCamera();
//     textRecognizer.close();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) {
//       return;
//     }

//     if (state == AppLifecycleState.inactive) {
//       _stopCamera();
//     } else if (state == AppLifecycleState.resumed &&
//         _cameraController != null &&
//         _cameraController!.value.isInitialized) {
//       _startCamera();
//     }
//   }

//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _future,
//       builder: (context, snapshot) {
//         return Stack(
//           children: [
//             if (_isPermissionGranted)
//               FutureBuilder<List<CameraDescription>>(
//                 future: availableCameras(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     _initCameraController(snapshot.data!);

//                     return Center(child: CameraPreview(_cameraController!));
//                   } else {
//                     return const LinearProgressIndicator();
//                   }
//                 },
//               ),
//             Scaffold(
//               appBar: AppBar(
//                 title: const Text('SCAN'),
//                 automaticallyImplyLeading: false,
//                 centerTitle: true,
//               ),
//               backgroundColor: _isPermissionGranted ? Colors.transparent : null,
//               body: _isPermissionGranted
//                   ? Column(
//                       children: [
//                         Expanded(
//                           child: Container(),
//                         ),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width / 2.4,
//                           child: Padding(
//                             padding: const EdgeInsets.only(bottom: 40),
//                             child: ElevatedButton(
//                               onPressed: _scanImage,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Theme.of(context).primaryColor,
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 15),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   if (isLoading)
//                                     const SizedBox(
//                                       height: 21,
//                                       width: 21,
//                                       child: CircularProgressIndicator(
//                                         color: Colors.white,
//                                         strokeWidth: 2.57,
//                                       ),
//                                     ),
//                                   if (isLoading)
//                                     const SizedBox(
//                                       width: 20,
//                                     ),
//                                   const Text("Scan Text",
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                       )),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   : Center(
//                       child: Container(
//                         padding: const EdgeInsets.only(left: 24.0, right: 24.0),
//                         child: const Text(
//                           'Camera permission denied',
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _requestCameraPermission() async {
//     final status = await Permission.camera.request();
//     _isPermissionGranted = status == PermissionStatus.granted;
//   }

//   void _startCamera() {
//     if (_cameraController != null) {
//       _cameraSelected(_cameraController!.description);
//     }
//   }

//   void _stopCamera() {
//     if (_cameraController != null) {
//       _cameraController?.dispose();
//     }
//   }

//   void _initCameraController(List<CameraDescription> cameras) {
//     if (_cameraController != null) {
//       return;
//     }

//     // Select the first rear camera.
//     CameraDescription? camera;
//     for (var i = 0; i < cameras.length; i++) {
//       final CameraDescription current = cameras[i];
//       if (current.lensDirection == CameraLensDirection.back) {
//         camera = current;
//         break;
//       }
//     }

//     if (camera != null) {
//       _cameraSelected(camera);
//     }
//   }

//   Future<void> _cameraSelected(CameraDescription camera) async {
//     _cameraController = CameraController(
//       camera,
//       ResolutionPreset.max,
//       enableAudio: false,
//     );

//     await _cameraController!.initialize();
//     await _cameraController!.setFlashMode(FlashMode.off);

//     if (!mounted) {
//       return;
//     }
//     setState(() {});
//   }

//   Future<void> _scanImage() async {
//     setState(() {
//       isLoading = true;
//     });
//     if (_cameraController == null) return;

//     final navigator = Navigator.of(context);

//     try {
//       final pictureFile = await _cameraController!.takePicture();

//       final file = File(pictureFile.path);

//       final inputImage = InputImage.fromFile(file);
//       final recognizedText = await textRecognizer.processImage(inputImage);

//       await navigator.push(
//         MaterialPageRoute(
//           builder: (BuildContext context) =>
//               ResultScreen(text: recognizedText.text),
//         ),
//       );
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('An error occurred when scanning text'),
//         ),
//       );
//     }
//   }
// }

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'result_screen.dart';

class TextRecognitionFromCamera extends StatefulWidget {
  const TextRecognitionFromCamera({super.key});

  @override
  State<TextRecognitionFromCamera> createState() =>
      _TextRecognitionFromCameraState();
}

class _TextRecognitionFromCameraState extends State<TextRecognitionFromCamera>
    with WidgetsBindingObserver {
  bool _isPermissionGranted = false;

  late final Future<void> _future;
  CameraController? _cameraController;

  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            if (_isPermissionGranted)
              FutureBuilder<List<CameraDescription>>(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _initCameraController(snapshot.data!);

                    return Center(child: CameraPreview(_cameraController!));
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            Scaffold(
              appBar: AppBar(
                title: const Text('SCAN TEXT'),
                automaticallyImplyLeading: false,
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.shade400,
                        Colors.deepPurple.shade700
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              backgroundColor: _isPermissionGranted ? Colors.transparent : null,
              body: _isPermissionGranted
                  ? Column(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 40),
                          child: ElevatedButton(
                            onPressed: _scanImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple.shade400,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 5,
                              shadowColor: Colors.deepPurple.withOpacity(0.3),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Text(
                                    "Scan Text",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt,
                              size: 60,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Camera permission denied',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _requestCameraPermission,
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
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _isPermissionGranted = status == PermissionStatus.granted;
    });
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.off);

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scanImage() async {
    setState(() {
      isLoading = true;
    });
    if (_cameraController == null) return;

    final navigator = Navigator.of(context);

    try {
      final pictureFile = await _cameraController!.takePicture();

      final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);
      final recognizedText = await textRecognizer.processImage(inputImage);

      await navigator.push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              ResultScreen(text: recognizedText.text),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
