// Support multiple photos and dynamic folder
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UploadUser extends StatefulWidget {
  @override
  _UploadUserState createState() => _UploadUserState();
}

class _UploadUserState extends State<UploadUser> {
  List<File> _selectedImages = [];
  TextEditingController _folderNameController = TextEditingController();

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
    final String serverUrl = 'http://10.106.7.236:5000/upload';
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
        // Handle success, if needed
      } else {
        print(
            'Failed to send images to the server. Status code: ${response.statusCode}');
        // Handle failure, if needed
      }
    } catch (e) {
      print('Error sending images: $e');
      // Handle error, if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _folderNameController,
            decoration: InputDecoration(
              labelText: 'Enter Folder Name',
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
        ],
      ),
    );
  }
}
