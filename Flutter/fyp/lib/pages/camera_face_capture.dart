// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';

// class CameraFaceCapture extends StatefulWidget {
//   const CameraFaceCapture({super.key});

//   @override
//   State<CameraFaceCapture> createState() => _CameraFaceCaptureState();
// }

// class _CameraFaceCaptureState extends State<CameraFaceCapture> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text(
//           'Add New User',
//           style: TextStyle(
//               color: Colors.black87, fontSize: 25, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 10),

//               // Live camera
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 0, 106, 95),
//                   borderRadius: BorderRadius.circular(40),
//                 ),
//                 child: SizedBox(
//                   width: 250,
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 10),
//                         const Text(
//                           'Live Camera',
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                         SizedBox(height: 10),

//                         // Here camera display preview

//                         SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             // The button use to start the recordimh
//                           },
//                           child: const Text('Start record'),
//                         ),
//                         const SizedBox(height: 10),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class CameraFaceCapture extends StatefulWidget {
//   const CameraFaceCapture({super.key});

//   @override
//   State<CameraFaceCapture> createState() => _CameraFaceCaptureState();
// }

// class _CameraFaceCaptureState extends State<CameraFaceCapture> {
//   late CameraController _cameraController;
//   late VideoPlayerController _videoController;

//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//   }

//   Future<void> initializeCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;
//     final frontCamera = cameras.firstWhere(
//       (camera) => camera.lensDirection == CameraLensDirection.front,
//       orElse: () => cameras.first,
//     );

//     _cameraController = CameraController(
//       //firstCamera,
//       frontCamera,
//       ResolutionPreset.high,
//     );

//     await _cameraController.initialize();
//     if (!mounted) return;

//     setState(() {});
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     _videoController.dispose();
//     super.dispose();
//   }

//   Future<void> startRecording() async {
//     const videoPath =
//         'path_to_save_video/video.mp4'; // Replace with your desired path
//     _videoController = VideoPlayerController.file(File(videoPath));

//     await _cameraController.startVideoRecording();
//     _videoController.initialize();

//     await _videoController.play();
//     await Future.delayed(const Duration(seconds: 15));

//     await _cameraController.stopVideoRecording();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_cameraController.value.isInitialized) {
//       return Container();
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text(
//           'Add New User',
//           style: TextStyle(
//             color: Colors.black87,
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 0, 106, 95),
//                   borderRadius: BorderRadius.circular(40),
//                 ),
//                 child: SizedBox(
//                   width: 350,
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 10),
//                         const Text(
//                           'Live Camera',
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                         SizedBox(height: 10),
//                         AspectRatio(
//                           // aspectRatio: _cameraController.value.aspectRatio,
//                           aspectRatio: 1.0,
//                           child: CameraPreview(_cameraController),
//                         ),
//                         SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: startRecording,
//                           child: const Text('Start record'),
//                         ),
//                         const SizedBox(height: 10),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class CameraFaceCapture extends StatefulWidget {
//   const CameraFaceCapture({super.key});

//   @override
//   State<CameraFaceCapture> createState() => _CameraFaceCaptureState();
// }

// class _CameraFaceCaptureState extends State<CameraFaceCapture> {
//   late CameraController _cameraController;
//   late VideoPlayerController _videoController;

//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//     _videoController =
//         VideoPlayerController.network(''); // Initialize with an empty source
//   }

//   Future<void> initializeCamera() async {
//     final cameras = await availableCameras();
//     final frontCamera = cameras.firstWhere(
//       (camera) => camera.lensDirection == CameraLensDirection.front,
//       orElse: () => cameras.first,
//     );

//     _cameraController = CameraController(
//       frontCamera,
//       ResolutionPreset.high,
//     );

//     await _cameraController.initialize();
//     if (!mounted) return;

//     setState(() {});
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     _videoController.dispose();
//     super.dispose();
//   }

//   Future<void> startRecording() async {
//     final videoPath =
//         'path_to_save_video/video.mp4'; // Replace with your desired path
//     await _cameraController.startVideoRecording();
//     await Future.delayed(const Duration(seconds: 15));
//     await _cameraController.stopVideoRecording();

//     // Dispose of the original video controller
//     await _videoController.pause();
//     await _videoController.dispose();

//     // Play the recorded video
//     _videoController = VideoPlayerController.file(File(videoPath));
//     await _videoController.initialize();
//     await _videoController.play();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_cameraController.value.isInitialized) {
//       return Container();
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text(
//           'Add New User',
//           style: TextStyle(
//             color: Colors.black87,
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 0, 106, 95),
//                   borderRadius: BorderRadius.circular(40),
//                 ),
//                 child: SizedBox(
//                   width: 350,
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 10),
//                         const Text(
//                           'Live Camera',
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                         SizedBox(height: 10),
//                         AspectRatio(
//                           aspectRatio: 1.0,
//                           child: CameraPreview(_cameraController),
//                         ),
//                         SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: startRecording,
//                           child: const Text('Start record'),
//                         ),
//                         const SizedBox(height: 10),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               _videoController.value.isInitialized
//                   ? AspectRatio(
//                       aspectRatio: 1.0, // Display video in 1:1 aspect ratio
//                       child: CropVideoWidget(videoController: _videoController),
//                     )
//                   : Container(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CropVideoWidget extends StatefulWidget {
//   final VideoPlayerController videoController;

//   const CropVideoWidget({required this.videoController, Key? key})
//       : super(key: key);

//   @override
//   _CropVideoWidgetState createState() => _CropVideoWidgetState();
// }

// class _CropVideoWidgetState extends State<CropVideoWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return FittedBox(
//       fit: BoxFit.cover,
//       child: SizedBox(
//         width: widget.videoController.value.size.width,
//         height: widget.videoController.value.size.height,
//         child: VideoPlayer(widget.videoController),
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class CameraFaceCapture extends StatefulWidget {
//   const CameraFaceCapture({Key? key}) : super(key: key);

//   @override
//   _CameraFaceCaptureState createState() => _CameraFaceCaptureState();
// }

// class _CameraFaceCaptureState extends State<CameraFaceCapture> {
//   late CameraController _cameraController;
//   late VideoPlayerController _videoController;

//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//     _videoController =
//         VideoPlayerController.network(''); // Initialize with an empty source
//   }

//   Future<void> initializeCamera() async {
//     final cameras = await availableCameras();
//     final frontCamera = cameras.firstWhere(
//       (camera) => camera.lensDirection == CameraLensDirection.front,
//       orElse: () => cameras.first,
//     );

//     _cameraController = CameraController(
//       frontCamera,
//       ResolutionPreset.high,
//     );

//     await _cameraController.initialize();
//     if (!mounted) return;

//     setState(() {});
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     _videoController.dispose();
//     super.dispose();
//   }

//   Future<void> startRecording() async {
//     const videoPath =
//         'storage/emulated/record.mp4'; // Replace with your desired path

//     await _cameraController.startVideoRecording();

//     // Delay for 15 seconds
//     await Future.delayed(const Duration(seconds: 15));

//     await _cameraController.stopVideoRecording();

//     // Dispose of the original video controller
//     await _videoController.pause();
//     await _videoController.dispose();

//     // Play the recorded video
//     _videoController = VideoPlayerController.file(File(videoPath));
//     await _videoController.initialize();
//     await _videoController.play();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_cameraController.value.isInitialized) {
//       return Container();
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add New User'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 0, 106, 95),
//                   borderRadius: BorderRadius.circular(40),
//                 ),
//                 child: SizedBox(
//                   width: 350,
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 10),
//                         const Text(
//                           'Live Camera',
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                         SizedBox(height: 10),
//                         AspectRatio(
//                           aspectRatio: 1.0,
//                           child: CameraPreview(_cameraController),
//                         ),
//                         SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: startRecording,
//                           child: const Text('Start record'),
//                         ),
//                         const SizedBox(height: 10),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               _videoController.value.isInitialized
//                   ? AspectRatio(
//                       aspectRatio: 1.0, // Display video in 1:1 aspect ratio
//                       child: CropVideoWidget(videoController: _videoController),
//                     )
//                   : Container(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CropVideoWidget extends StatefulWidget {
//   final VideoPlayerController videoController;

//   const CropVideoWidget({required this.videoController, Key? key})
//       : super(key: key);

//   @override
//   _CropVideoWidgetState createState() => _CropVideoWidgetState();
// }

// class _CropVideoWidgetState extends State<CropVideoWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return FittedBox(
//       fit: BoxFit.cover,
//       child: SizedBox(
//         width: widget.videoController.value.size.width,
//         height: widget.videoController.value.size.height,
//         child: VideoPlayer(widget.videoController),
//       ),
//     );
//   }
// }

// Working but only a single picture per take
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:video_player/video_player.dart';

// class CameraFaceCapture extends StatefulWidget {
//   const CameraFaceCapture({super.key});

//   @override
//   State<CameraFaceCapture> createState() => _CameraFaceCaptureState();
// }

// class _CameraFaceCaptureState extends State<CameraFaceCapture> {
//   late CameraController _cameraController;
//   late VideoPlayerController _videoController;
//   bool isVideoSaved = false;
//   ScreenshotController screenshotController = ScreenshotController();

//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//     _videoController =
//         VideoPlayerController.network(''); // Initialize with an empty source
//   }

//   SaveToGallery() {
//     screenshotController.capture().then((Uint8List? image) {
//       saveScreenshot(image!);
//     });

//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text('Image saved to gallery')));
//   }

//   saveScreenshot(Uint8List bytes) async {
//     final time = DateTime.now()
//         .toIso8601String()
//         .replaceAll('.', '-')
//         .replaceAll(':', '-');
//     final name = "ScreenShot$time";
//     await ImageGallerySaver.saveImage(bytes, name: name);
//   }

//   Future<void> initializeCamera() async {
//     final cameras = await availableCameras();
//     final frontCamera = cameras.firstWhere(
//       (camera) => camera.lensDirection == CameraLensDirection.front,
//       orElse: () => cameras.first,
//     );

//     _cameraController = CameraController(
//       frontCamera,
//       ResolutionPreset.high,
//     );

//     await _cameraController.initialize();
//     if (!mounted) return;

//     setState(() {});
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     _videoController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_cameraController.value.isInitialized) {
//       return Container();
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text(
//           'Add New User',
//           style: TextStyle(
//               color: Colors.black87, fontSize: 25, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               const SizedBox(height: 10),
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 0, 106, 95),
//                   borderRadius: BorderRadius.circular(40),
//                 ),
//                 child: SizedBox(
//                   width: 350,
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         SizedBox(height: 10),
//                         const Text(
//                           'Live Camera',
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                         const SizedBox(height: 10),
//                         Screenshot(
//                           controller: screenshotController,
//                           child: AspectRatio(
//                             aspectRatio: 9 / 16,
//                             child: CameraPreview(_cameraController),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             SaveToGallery();
//                           },
//                           child: const Text('Take a picture'),
//                         ),
//                         const SizedBox(height: 10),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Working, multiple image can be capture and upload, but not indicator success
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// class CameraFaceCapture extends StatefulWidget {
//   const CameraFaceCapture({Key? key}) : super(key: key);

//   @override
//   State<CameraFaceCapture> createState() => _CameraFaceCaptureState();
// }

// class _CameraFaceCaptureState extends State<CameraFaceCapture> {
//   late CameraController _cameraController;
//   bool isCapturing = false;
//   ScreenshotController screenshotController = ScreenshotController();

//   List<File> _selectedImages = [];
//   TextEditingController _folderNameController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//   }

//   SaveToGallery() async {
//     for (int i = 0; i < 15; i++) {
//       if (!isCapturing) break;

//       screenshotController.capture().then((Uint8List? image) {
//         saveScreenshot(image!, i + 1);
//       });

//       await Future.delayed(Duration(milliseconds: 500));
//     }

//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text('Image capture completed')));
//   }

//   saveScreenshot(Uint8List bytes, int index) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final path = '${directory!.path}/dataset/Eyeman';
//     await Directory(path).create(recursive: true);

//     final time = DateTime.now()
//         .toIso8601String()
//         .replaceAll('.', '-')
//         .replaceAll(':', '-');
//     //final name = "$path/ScreenShot$time_$index.png";
//     final name = "$path/ScreenShot${time}_$index.png";

//     await ImageGallerySaver.saveImage(bytes, name: name);
//   }

//   Future<void> initializeCamera() async {
//     final cameras = await availableCameras();
//     final frontCamera = cameras.firstWhere(
//       (camera) => camera.lensDirection == CameraLensDirection.front,
//       orElse: () => cameras.first,
//     );

//     _cameraController = CameraController(
//       frontCamera,
//       ResolutionPreset.high,
//     );

//     await _cameraController.initialize();
//     if (!mounted) return;

//     setState(() {});
//   }

//   Future<void> _pickImages() async {
//     final picker = ImagePicker();
//     final pickedImages = await picker.pickMultiImage();
//     if (pickedImages != null) {
//       setState(() {
//         _selectedImages =
//             pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
//       });
//     }
//   }

//   Future<void> _sendImages() async {
//     if (_selectedImages.isEmpty) {
//       // No images to send
//       return;
//     }

//     if (_folderNameController.text.isEmpty) {
//       // Folder name is required
//       return;
//     }

//     // Replace with your Raspberry Pi's IP address and Flask server endpoint
//     // NEED TO HAVE FIREBASE SUPPORT FOR THIS PART
//     final String serverUrl = 'http://10.106.7.236:5000/upload';
//     var request = http.MultipartRequest('POST', Uri.parse(serverUrl));

//     // Add folder name to the request
//     request.fields['folder_name'] = _folderNameController.text;

//     for (var image in _selectedImages) {
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'images',
//           image.path,
//         ),
//       );
//     }

//     try {
//       final response = await request.send();
//       if (response.statusCode == 200) {
//         print('Images successfully sent to the server!');
//         // Handle success, if needed
//       } else {
//         print(
//             'Failed to send images to the server. Status code: ${response.statusCode}');
//         // Handle failure, if needed
//       }
//     } catch (e) {
//       print('Error sending images: $e');
//       // Handle error, if needed
//     }
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_cameraController.value.isInitialized) {
//       return Container();
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text(
//           'Add New User',
//           style: TextStyle(
//               color: Colors.black87, fontSize: 25, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               const SizedBox(height: 10),
//               // Live camera section
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 0, 106, 95),
//                   borderRadius: BorderRadius.circular(40),
//                 ),
//                 child: SizedBox(
//                   width: 350,
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         SizedBox(height: 10),
//                         const Text(
//                           'Live Camera',
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                         const SizedBox(height: 10),
//                         Screenshot(
//                           controller: screenshotController,
//                           child: AspectRatio(
//                             aspectRatio: 9 / 16,
//                             child: CameraPreview(_cameraController),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             isCapturing = true;
//                             SaveToGallery();
//                           },
//                           child: const Text('Take 15 pictures'),
//                         ),
//                         const SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             isCapturing = false;
//                           },
//                           child: const Text('Stop capturing'),
//                         ),
//                         const SizedBox(height: 10),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),

//               // Upload user
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 0, 106, 95),
//                   borderRadius: BorderRadius.circular(40),
//                 ),
//                 child: SizedBox(
//                   width: 350,
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         SizedBox(height: 10),
//                         const Text(
//                           'Upload photo to system',
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                         const SizedBox(height: 10),
//                         // Screenshot(
//                         //   controller: screenshotController,
//                         //   child: AspectRatio(
//                         //     aspectRatio: 9 / 16,
//                         //     child: CameraPreview(_cameraController),
//                         //   ),
//                         // ),
//                         TextField(
//                           controller: _folderNameController,
//                           decoration: InputDecoration(
//                             labelText: 'Enter Folder Name',
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: _pickImages,
//                           child: Text('Pick Images'),
//                         ),
//                         SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: _sendImages,
//                           child: Text('Send Images'),
//                         ),

//                         // const SizedBox(height: 10),
//                         // ElevatedButton(
//                         //   onPressed: () {
//                         //     isCapturing = true;
//                         //     SaveToGallery();
//                         //   },
//                         //   child: const Text('Take 15 pictures'),
//                         // ),
//                         // const SizedBox(height: 10),
//                         // ElevatedButton(
//                         //   onPressed: () {
//                         //     isCapturing = false;
//                         //   },
//                         //   child: const Text('Stop capturing'),
//                         // ),
//                         const SizedBox(height: 10),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Working, multiple image can be capture and upload, with indicator success
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// class CameraFaceCapture extends StatefulWidget {
//   const CameraFaceCapture({Key? key}) : super(key: key);

//   @override
//   State<CameraFaceCapture> createState() => _CameraFaceCaptureState();
// }

// class _CameraFaceCaptureState extends State<CameraFaceCapture> {
//   late CameraController _cameraController;
//   bool isCapturing = false;
//   ScreenshotController screenshotController = ScreenshotController();

//   List<File> _selectedImages = [];
//   TextEditingController _folderNameController = TextEditingController();

//   int capturedPhotoCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//   }

//   SaveToGallery() async {
//     for (int i = 0; i < 10; i++) {
//       if (!isCapturing) break;

//       screenshotController.capture().then((Uint8List? image) {
//         saveScreenshot(image!, i + 1);

//         //Display cout image saved
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(
//         //     content: Text('Current photo: $capturedPhotoCount'),
//         //   ),
//         // );
//         setState(() {
//           capturedPhotoCount++;
//         });
//       });

//       await Future.delayed(Duration(milliseconds: 1000));
//     }

//     // Print when complete capture images
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Image capture completed: $capturedPhotoCount'),
//       ),
//     );
//   }

//   saveScreenshot(Uint8List bytes, int index) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final path = '${directory!.path}';
//     await Directory(path).create(recursive: true);

//     final time = DateTime.now()
//         .toIso8601String()
//         .replaceAll('.', '-')
//         .replaceAll(':', '-');

//     final name = "$path/ScreenShot${time}_$index.png";

//     await ImageGallerySaver.saveImage(bytes, name: name);
//   }

//   Future<void> initializeCamera() async {
//     final cameras = await availableCameras();
//     final frontCamera = cameras.firstWhere(
//       (camera) => camera.lensDirection == CameraLensDirection.front,
//       orElse: () => cameras.first,
//     );

//     _cameraController = CameraController(
//       frontCamera,
//       ResolutionPreset.high,
//     );

//     await _cameraController.initialize();
//     if (!mounted) return;

//     setState(() {});
//   }

//   Future<void> _pickImages() async {
//     final picker = ImagePicker();
//     final pickedImages = await picker.pickMultiImage();
//     if (pickedImages != null) {
//       setState(() {
//         _selectedImages =
//             pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
//       });
//     }
//   }

//   Future<void> _sendImages() async {
//     if (_selectedImages.isEmpty) {
//       // No images to send
//       return;
//     }

//     if (_folderNameController.text.isEmpty) {
//       // Folder name is required
//       return;
//     }

//     // Replace with your Raspberry Pi's IP address and Flask server endpoint
//     // NEED TO HAVE FIREBASE SUPPORT FOR THIS PART
//     final String serverUrl = 'http://10.106.7.236:5000/upload';
//     var request = http.MultipartRequest('POST', Uri.parse(serverUrl));

//     // Add folder name to the request
//     request.fields['folder_name'] = _folderNameController.text;

//     for (var image in _selectedImages) {
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'images',
//           image.path,
//         ),
//       );
//     }

//     try {
//       final response = await request.send();
//       if (response.statusCode == 200) {
//         print('Images successfully sent to the server!');
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Images successfully uploaded')));
//         // Handle success, if needed
//       } else {
//         print(
//             'Failed to send images to the server. Status code: ${response.statusCode}');
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text(
//                 'Failed to upload images. Status code: ${response.statusCode}')));
//         // Handle failure, if needed
//       }
//     } catch (e) {
//       print('Error sending images: $e');
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error uploading images: $e')));
//       // Handle error, if needed
//     }
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_cameraController.value.isInitialized) {
//       return Container();
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text(
//           'Add New User',
//           style: TextStyle(
//               color: Colors.black87, fontSize: 25, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               const SizedBox(height: 10),
//               // Live camera section
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 0, 106, 95),
//                   borderRadius: BorderRadius.circular(40),
//                 ),
//                 child: SizedBox(
//                   width: 350,
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         SizedBox(height: 10),
//                         const Text(
//                           'Live Camera',
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                         const SizedBox(height: 10),
//                         Screenshot(
//                           controller: screenshotController,
//                           child: AspectRatio(
//                             aspectRatio: 9 / 16,
//                             child: CameraPreview(_cameraController),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         // Counter display
//                         Text(
//                           'Current Photo: $capturedPhotoCount',
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             isCapturing = true;
//                             SaveToGallery();
//                           },
//                           child: const Text('Take 15 pictures'),
//                         ),
//                         const SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             isCapturing = false;
//                           },
//                           child: const Text('Stop capturing'),
//                         ),
//                         const SizedBox(height: 10),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),

//               // Upload user
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 0, 106, 95),
//                   borderRadius: BorderRadius.circular(40),
//                 ),
//                 child: SizedBox(
//                   width: 350,
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         SizedBox(height: 10),
//                         const Text(
//                           'Upload photo to system',
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                         const SizedBox(height: 10),
//                         // Screenshot(
//                         //   controller: screenshotController,
//                         //   child: AspectRatio(
//                         //     aspectRatio: 9 / 16,
//                         //     child: CameraPreview(_cameraController),
//                         //   ),
//                         // ),
//                         TextField(
//                           controller: _folderNameController,
//                           decoration: InputDecoration(
//                             hintText: 'Enter your Name',
//                             hintStyle: const TextStyle(color: Colors.white),
//                             enabledBorder: const OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.white),
//                             ),
//                             suffixIcon: IconButton(
//                               onPressed: () {
//                                 _folderNameController.clear();
//                               },
//                               icon: const Icon(
//                                 Icons.clear,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                           // decoration: InputDecoration(
//                           //   labelText: 'Enter Folder Name',
//                           // ),
//                         ),
//                         SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: _pickImages,
//                           child: Text('Pick Images'),
//                         ),
//                         SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: _sendImages,
//                           child: Text('Send Images'),
//                         ),
//                         const SizedBox(height: 10),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Working, multiple image can be capture and upload, with indicator success, solve camera initialization error
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
    for (int i = 0; i < 50; i++) {
      if (!isCapturing) break;

      screenshotController.capture().then((Uint8List? image) {
        saveScreenshot(image!, i + 1);
        setState(() {
          capturedPhotoCount++;
        });
      });

      //await Future.delayed(Duration(milliseconds: 100));
    }

    if (capturedPhotoCount == 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image capture completed: $capturedPhotoCount'),
        ),
      );
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

    // Replace with your Raspberry Pi's IP address and Flask server endpoint
    // NEED TO HAVE FIREBASE SUPPORT FOR THIS PART
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

  // Future<void> startTraining() async {
  //   final String serverUrl = 'http://10.106.7.236:5000/start_training';
  //   try {
  //     final response = await http.get(Uri.parse(serverUrl));
  //     if (response.statusCode == 200) {
  //       print('Training started!');
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text('Training started')));
  //     } else {
  //       print('Failed to start training. Status code: ${response.statusCode}');
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text(
  //               'Failed to start training. Status code: ${response.statusCode}')));
  //     }
  //   } catch (e) {
  //     print('Error starting training: $e');
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Error starting training: $e')));
  //   }
  // }

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

    // database.child('RaspberryPi/IPAddressRPI/').onValue.listen(
    //   (event) {
    //     String temp = event.snapshot.value.toString();
    //     wifiIPAddress = temp.toString();
    //     if (currentIPA != wifiIPAddress) {
    //       setState(
    //         () {
    //           currentIPA = wifiIPAddress;
    //         },
    //       );
    //     }
    //   },
    // );

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
                          style: TextStyle(fontSize: 20, color: Colors.white),
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
                          'Current Photo: $capturedPhotoCount/50',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            isCapturing = true;
                            SaveToGallery();
                          },
                          child: const Text('Take 50 pictures'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            isCapturing = false;
                          },
                          child: const Text('Stop capturing'),
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

              // Upload user
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
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        TextField(
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
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _pickImages,
                          child: Text('Pick Images'),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _sendImages,
                          child: Text('Send Images'),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            await database.update({'RaspberryPi/Training/': 1});
                          },
                          child: Text('Start Training'),
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
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
