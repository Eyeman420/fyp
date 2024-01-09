// import 'package:flutter/material.dart';

// class ManageUser extends StatefulWidget {
//   const ManageUser({super.key});

//   @override
//   State<ManageUser> createState() => _ManageUserState();
// }

// class _ManageUserState extends State<ManageUser> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text(
//           'Manage Current Users',
//           style: TextStyle(
//               color: Colors.black87, fontSize: 25, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Text("Manage Current Users"),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';

// class ManageUser extends StatefulWidget {
//   const ManageUser({super.key});

//   @override
//   State<ManageUser> createState() => _ManageUserState();
// }

// class _ManageUserState extends State<ManageUser> {
//   String temp_Path = "";
//   String appPath = "";

//   getPathLocation() async {
//     Directory tempDir = await getTemporaryDirectory();
//     temp_Path = tempDir.path;
//     print("temp_path: $temp_Path");
//     Directory appDir = await getApplicationDocumentsDirectory();
//     appPath = appDir.path;
//     print("app_path: $appPath");
//   }

//   @override
//   void initState() {
//     getPathLocation();
//     super.initState();
//   }

//   @override
//   void setState(VoidCallback fn) {
//     // TODO: implement setState
//     getPathLocation();
//     super.setState(fn);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//             padding: EdgeInsets.all(10),
//             alignment: Alignment.center,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Temp Path: $temp_Path"),
//                 Text("App Path: $appPath")
//               ],
//             )));
//   }
// }

// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:image_picker/image_picker.dart';

// class ManageUser extends StatefulWidget {
//   @override
//   _ManageUserState createState() => _ManageUserState();
// }

// class _ManageUserState extends State<ManageUser> {
//   final picker = ImagePicker();
//   late File _image = File(
//       '/home/eyeman/Documents/NewFP/dataset/Eyeman/image_0.jpg'); // Set a default image path

//   Future getImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   Future uploadImage() async {
//     String url =
//         'http://10.106.7.236:5000/upload'; // replace with your Raspberry Pi's IP

//     Dio dio = Dio();
//     FormData formData = FormData.fromMap({
//       'file': await MultipartFile.fromFile(_image.path),
//     });

//     try {
//       Response response = await dio.post(url, data: formData);
//       print(response.data);
//     } catch (e) {
//       print('Error uploading image: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Upload'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _image == null ? Text('No image selected.') : Image.file(_image),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: getImage,
//               child: Text('Pick Image'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: uploadImage,
//               child: Text('Upload Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Working to upload many photos but cannot make it in one folder
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// class ManageUser extends StatefulWidget {
//   @override
//   _ManageUserState createState() => _ManageUserState();
// }

// class _ManageUserState extends State<ManageUser> {
//   List<File> _selectedImages = [];

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

//     // Replace with your Raspberry Pi's IP address and Flask server endpoint
//     final String serverUrl = 'http://10.106.7.236:5000/upload';

//     var request = http.MultipartRequest('POST', Uri.parse(serverUrl));

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
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Upload App'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             onPressed: _pickImages,
//             child: Text('Pick Images'),
//           ),
//           SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: _sendImages,
//             child: Text('Send Images'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Support multiple photos and dynamic folder
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// class ManageUser extends StatefulWidget {
//   @override
//   _ManageUserState createState() => _ManageUserState();
// }

// class _ManageUserState extends State<ManageUser> {
//   List<File> _selectedImages = [];
//   TextEditingController _folderNameController = TextEditingController();

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
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Upload App'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           TextField(
//             controller: _folderNameController,
//             decoration: InputDecoration(
//               labelText: 'Enter Folder Name',
//             ),
//           ),
//           SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: _pickImages,
//             child: Text('Pick Images'),
//           ),
//           SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: _sendImages,
//             child: Text('Send Images'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:image_picker/image_picker.dart';

// class ManageUser extends StatefulWidget {
//   @override
//   _ManageUserState createState() => _ManageUserState();
// }

// class _ManageUserState extends State<ManageUser> {
//   final picker = ImagePicker();
//   List<File> _images = [];
//   late String _folderName;

//   @override
//   void initState() {
//     super.initState();
//     _folderName = 'Eyeman'; // Default folder name
//   }

//   Future<void> pickImages() async {
//     List<XFile>? pickedFiles = await picker.pickMultiImage();

//     setState(() {
//       if (pickedFiles != null) {
//         _images = pickedFiles.map((file) => File(file.path)).toList();
//       } else {
//         print('No images selected.');
//       }
//     });
//   }

//   Future<void> uploadImages() async {
//     String url =
//         'http://10.106.7.236:5000/upload'; // replace with your Raspberry Pi's IP

//     Dio dio = Dio();
//     List<MultipartFile> imageFiles =
//         _images.map((image) => MultipartFile.fromFileSync(image.path)).toList();

//     FormData formData = FormData.fromMap({
//       'files': imageFiles,
//       'folderName': _folderName,
//     });

//     try {
//       Response response = await dio.post(url, data: formData);
//       print(response.data);
//     } catch (e) {
//       print('Error uploading images: $e');
//     }
//   }

//   Future<void> promptFolderName() async {
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Enter Folder Name'),
//           content: TextField(
//             onChanged: (value) {
//               _folderName = value;
//             },
//             decoration: InputDecoration(labelText: 'Folder Name'),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 // You can perform additional actions when the user submits the folder name
//               },
//               child: Text('Submit'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Upload'),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               _images.isEmpty
//                   ? Text('No images selected.')
//                   : Column(
//                       children: _images.map((image) {
//                         return Image.file(image);
//                       }).toList(),
//                     ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: pickImages,
//                 child: Text('Pick Images'),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: promptFolderName,
//                 child: Text('Enter Folder Name'),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: uploadImages,
//                 child: Text('Upload Images'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

// class ManageUser extends StatefulWidget {
//   const ManageUser({super.key});

//   @override
//   State<ManageUser> createState() => _ManageUserState();
// }

// class _ManageUserState extends State<ManageUser> {
//   List<Directory> folders = [];

//   @override
//   void initState() {
//     super.initState();
//     _listFolders();
//   }

//   Future<void> _listFolders() async {
//     final dir = await getApplicationDocumentsDirectory();
//     final uploadsDir = Directory('${dir.path}/uploads');
//     final contents = uploadsDir.listSync();
//     setState(() {
//       folders = contents.whereType<Directory>().toList();
//     });
//   }

//   void _deleteFolder(Directory folder) async {
//     await folder.delete(recursive: true);
//     _listFolders();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Folders in Uploads'),
//       ),
//       body: ListView.builder(
//         itemCount: folders.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(folders[index].path.split('/').last),
//             trailing: IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: () => _deleteFolder(folders[index]),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageUser extends StatefulWidget {
  const ManageUser({super.key});

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  List<String> folders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFolders();
  }

  Future<void> fetchFolders() async {
    var url = Uri.parse('http://10.106.0.25:5000/list-folders');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['folders'] as List;
        setState(() {
          folders = data.cast<String>();
          isLoading = false;
        });
      } else {
        // Handle server errors
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
    }
  }

  Future<void> deleteFolder(String folderName) async {
    var url = Uri.parse('http://10.106.0.25:5000/delete-folder');
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'folder_name': folderName}),
      );

      if (response.statusCode == 200) {
        // Folder deleted successfully, update UI
        fetchFolders();
      } else {
        // Handle server errors
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
    }
  }

  // Future<void> fetchFolders() async {
  //   var url = Uri.parse('http:10.106.7.236:5000/list-folders');
  //   try {
  //     var response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       var data = json.decode(response.body) as List;
  //       setState(() {
  //         folders = data.cast<String>();
  //         isLoading = false;
  //       });
  //     } else {
  //       // Handle server errors
  //       print('Server error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     // Handle network errors
  //     print('Error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage User'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: folders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(folders[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Folder'),
                            content: Text(
                                'Are you sure you want to delete this folder?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  deleteFolder(folders[index]);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),

      // : ListView.builder(
      //     itemCount: folders.length,
      //     itemBuilder: (context, index) {
      //       return ListTile(
      //         title: Text(folders[index]),
      //       );
      //     },
      //   ),
    );
  }
}
