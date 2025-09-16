import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FaceCaptureScreen extends StatefulWidget {
  const FaceCaptureScreen({super.key});

  @override
  State<FaceCaptureScreen> createState() => _FaceCaptureScreenState();
}

class _FaceCaptureScreenState extends State<FaceCaptureScreen> {
  late CameraController _controller;
  bool _isCameraInitialized = false;
  late List<CameraDescription> cameras;
  bool isFlashOn = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      print('Available cameras: $cameras');

      CameraDescription frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => throw Exception('Front camera not found'),
      );

      _controller = CameraController(frontCamera, ResolutionPreset.high);

      await _controller.initialize();
      print('Camera initialized successfully');

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print('Camera initialization error: $e');
    }
  }

  Future<void> captureImage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      XFile picture = await _controller.takePicture();
      final bytes = await picture.readAsBytes();
      img.Image? originalImage = img.decodeImage(bytes);

      if (originalImage == null) {
        print('Failed to decode image');
        return;
      }

      // Correct the orientation by rotating (90 degrees counter-clockwise)
      img.Image orientedImage = img.copyRotate(originalImage, -90);

      int centerX = orientedImage.width ~/ 2;
      int centerY = orientedImage.height ~/ 2;
      int radius =
          (orientedImage.width < orientedImage.height
                  ? orientedImage.width
                  : orientedImage.height) ~/
              2 -
          40;

      img.Image cropped = img.copyCrop(
        orientedImage,
        centerX - radius,
        centerY - radius,
        radius * 2,
        radius * 2,
      );

      img.Image circularImage = img.Image(radius * 2, radius * 2);

      for (int y = 0; y < radius * 2; y++) {
        for (int x = 0; x < radius * 2; x++) {
          int dx = x - radius;
          int dy = y - radius;
          if (dx * dx + dy * dy <= radius * radius) {
            circularImage.setPixel(x, y, cropped.getPixel(x, y));
          } else {
            circularImage.setPixel(x, y, img.getColor(0, 0, 0, 0));
          }
        }
      }

      final circularBytes = img.encodeJpg(circularImage);
      final circularFilePath =
          '${directory.path}/circular_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final circularFile = File(circularFilePath);
      await circularFile.writeAsBytes(circularBytes);

      print('Correctly Oriented Circular Image Saved at $circularFilePath');

      // ✅ Punch Out Success Popup
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'You Have Successfully Punched Out.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(File(circularFilePath)),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Name: Pritesh Pawar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Column(
                          children: [
                            Text(
                              'Punch In Time',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text('09:00 AM', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Punch Out Time',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text('06:00 PM', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );
    } catch (e) {
      print('Image capture error: $e');
    }
  }

  void toggleFlash() async {
    try {
      if (isFlashOn) {
        await _controller.setFlashMode(FlashMode.off);
      } else {
        await _controller.setFlashMode(FlashMode.torch);
      }
      setState(() {
        isFlashOn = !isFlashOn;
      });
    } catch (e) {
      print('Flash toggle error: $e');
    }
  }

  void switchCamera() async {
    try {
      final newLens =
          _controller.description.lensDirection == CameraLensDirection.front
              ? CameraLensDirection.back
              : CameraLensDirection.front;

      final newCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == newLens,
      );

      await _controller.dispose();
      _controller = CameraController(newCamera, ResolutionPreset.high);
      await _controller.initialize();

      setState(() {});

      print('Switched camera successfully');
    } catch (e) {
      print('Camera switch error: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Location')),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isCameraInitialized
              ? Stack(
                children: [
                  SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.previewSize!.height,
                        height: _controller.value.previewSize!.width,
                        child: CameraPreview(_controller),
                      ),
                    ),
                  ),

                  // ✅ Circular Blur Mask Layer
                  Positioned.fill(
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.black.withOpacity(
                            0.5,
                          ), // Outer dark overlay
                        ),
                        Center(
                          child: ClipOval(
                            child: Container(
                              width: 250,
                              height: 250,
                              color:
                                  Colors
                                      .transparent, // Fully transparent area inside circle
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: 160,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 180,
                    left: 20,
                    right: 20,
                    child: Column(
                      children: const [
                        Text(
                          'Center Your Face',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Align Your Face To The Center Of The Selfie Area And Then Take Photo',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            isFlashOn ? Icons.flash_off : Icons.flash_on,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: toggleFlash,
                        ),
                        GestureDetector(
                          onTap: captureImage,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.cameraswitch,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: switchCamera,
                        ),
                      ],
                    ),
                  ),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}

/// ✅ Proper Circular Clipper Implementation
class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path fullScreen =
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    Path circle =
        Path()..addOval(
          Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2 - 40),
            radius: 125,
          ),
        );

    return Path.combine(PathOperation.difference, fullScreen, circle);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
