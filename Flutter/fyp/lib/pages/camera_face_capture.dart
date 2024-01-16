// Working, multiple image can be capture and upload, with indicator success, solve camera initialization error
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CameraFaceCapture extends StatefulWidget {
  const CameraFaceCapture({Key? key}) : super(key: key);

  @override
  State<CameraFaceCapture> createState() => _CameraFaceCaptureState();
}

class _CameraFaceCaptureState extends State<CameraFaceCapture> {
  //FB Initialization
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  String wifiIPAddress = '';
  String currentIPA = '';
  // int training = 0;
  // int cTraining = 0;

  late CameraController _cameraController;
  bool isCapturing = false;
  ScreenshotController screenshotController = ScreenshotController();

  List<File> _selectedImages = [];
  TextEditingController _folderNameController = TextEditingController();

  int capturedPhotoCount = 0;

  late Future<void> _initializeCamera;

  @override
  void initState() {
    super.initState();
    _initializeCamera = _initializeCameraAsync();
  }

  Future<void> _initializeCameraAsync() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  SaveToGallery() async {
    //int i = 0;
    for (int i = 0; i < 20; i++) {
      if (!isCapturing) break;

      screenshotController.capture().then((Uint8List? image) {
        saveScreenshot(image!, i + 1);
        setState(() {
          capturedPhotoCount++;
        });
      });
    }
  }

  saveScreenshot(Uint8List bytes, int index) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory!.path}';
    await Directory(path).create(recursive: true);

    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');

    final name = "$path/ScreenShot${time}_$index.png";

    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _selectedImages =
            pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
      });
    }
  }

  Future<void> _sendImages() async {
    if (_selectedImages.isEmpty) {
      // No images to send
      return;
    }

    if (_folderNameController.text.isEmpty) {
      // Folder name is required
      return;
    }

    // Set the path for flutter to flask
    final String serverUrl = 'http://$currentIPA:5000/upload';
    var request = http.MultipartRequest('POST', Uri.parse(serverUrl));

    // Add folder name to the request
    request.fields['folder_name'] = _folderNameController.text;

    for (var image in _selectedImages) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'images',
          image.path,
        ),
      );
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Images successfully sent to the server!');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Images successfully uploaded')));
        // Handle success, if needed
      } else {
        print(
            'Failed to send images to the server. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Failed to upload images. Status code: ${response.statusCode}')));
        // Handle failure, if needed
      }
    } catch (e) {
      print('Error sending images: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error uploading images: $e')));
      // Handle error, if needed
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //getIPAddress raspberry pi
    database.child('RaspberryPi/IPAddressRPI/').onValue.listen(
      (event) {
        String temp = event.snapshot.value.toString();
        wifiIPAddress = temp.toString();
        if (currentIPA != wifiIPAddress) {
          setState(
            () {
              currentIPA = wifiIPAddress;
            },
          );
        }
      },
    );

    return FutureBuilder<void>(
      future: _initializeCamera,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildCameraScreen();
        } else {
          return _buildLoadingScreen();
        }
      },
    );
  }

  //When camera is ready
  Widget _buildCameraScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Add New User',
          style: TextStyle(
              color: Colors.black87, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10),
              // Live camera section
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 106, 95),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: SizedBox(
                  width: 350,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        const Text(
                          'Live Camera',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Screenshot(
                          controller: screenshotController,
                          child: AspectRatio(
                            aspectRatio: 9 / 16,
                            child: CameraPreview(_cameraController),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Counter display
                        Text(
                          'Current Photo: $capturedPhotoCount/20',
                          style: const TextStyle(
                              fontSize: 19, color: Colors.white),
                        ),

                        //Button Take pictures and Stop capturing
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {
                              isCapturing = true;
                              SaveToGallery();
                            },
                            child: const Text(
                              'Take pictures',
                              style: TextStyle(fontSize: 19),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {
                              isCapturing = false;
                            },
                            child: const Text(
                              'Stop capturing',
                              style: TextStyle(fontSize: 19),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // Upload user photos
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 106, 95),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: SizedBox(
                  width: 350,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        const Text(
                          'Upload photo to system',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _folderNameController,
                            decoration: InputDecoration(
                              hintText: 'Enter your Name',
                              hintStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _folderNameController.clear();
                                },
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Button Pick Images, Send Images, Start Training
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: _pickImages,
                            child: const Text(
                              'Pick Images',
                              style: TextStyle(fontSize: 19),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: _sendImages,
                            child: const Text(
                              'Send Images',
                              style: TextStyle(fontSize: 19),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () async {
                              await database
                                  .update({'RaspberryPi/Training/': 1});
                            },
                            child: const Text(
                              'Start Training',
                              style: TextStyle(fontSize: 19),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // If camera not ready
  Widget _buildLoadingScreen() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
