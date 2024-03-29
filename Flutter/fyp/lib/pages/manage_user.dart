// Working but UI not nice
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:firebase_database/firebase_database.dart';

// class ManageUser extends StatefulWidget {
//   const ManageUser({super.key});

//   @override
//   State<ManageUser> createState() => _ManageUserState();
// }

// class _ManageUserState extends State<ManageUser> {
//   List<String> folders = [];
//   bool isLoading = true;
//   //FB Initialization
//   final DatabaseReference database = FirebaseDatabase.instance.ref();
//   String wifiIPAddress = '';
//   String currentIPA = '';

//   @override
//   void initState() {
//     super.initState();
//     setupIPAddressListener();
//     //fetchFolders();
//   }

//   Future<void> setupIPAddressListener() async {
//     database.child('RaspberryPi/IPAddressRPI/').onValue.listen(
//       (event) {
//         String temp = event.snapshot.value.toString();
//         wifiIPAddress = temp.toString();
//         if (currentIPA != wifiIPAddress) {
//           setState(() {
//             currentIPA = wifiIPAddress;
//             print("CurrentIPA: $currentIPA");
//             fetchFolders(); // Call fetchFolders with the updated IP
//           });
//         }
//       },
//     );
//   }

//   Future<void> fetchFolders() async {
//     var url = Uri.parse('http://$currentIPA:5000/list-folders');
//     try {
//       var response = await http.get(url);
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body)['folders'] as List;
//         setState(() {
//           folders = data.cast<String>();
//           isLoading = false;
//         });
//       } else {
//         // Handle server errors
//         print('Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Handle network errors
//       print('Error: $e');
//     }
//   }

//   Future<void> deleteFolder(String folderName) async {
//     var url = Uri.parse('http://$currentIPA:5000/delete-folder');
//     try {
//       var response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'folder_name': folderName}),
//       );

//       if (response.statusCode == 200) {
//         // Folder deleted successfully, update UI
//         // fetchFolders();
//       } else {
//         // Handle server errors
//         print('Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Handle network errors
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text(
//           'Manage User',
//           style: TextStyle(
//               color: Colors.black87, fontSize: 25, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Expanded(
//                   child: ListView.builder(
//                     itemCount: folders.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(
//                           folders[index],
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         trailing: IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () {
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   title: Text('Delete Folder'),
//                                   content: Text(
//                                       'Are you sure you want to delete this folder?'),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.of(context).pop();
//                                       },
//                                       child: Text('Cancel'),
//                                     ),
//                                     TextButton(
//                                       onPressed: () {
//                                         deleteFolder(folders[index]);
//                                         Navigator.of(context).pop();
//                                       },
//                                       child: Text('Delete'),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//           //const SizedBox(height: 16),
//           SizedBox(
//             width: 300,
//             child: ElevatedButton(
//               onPressed: () async {
//                 await database.update({'RaspberryPi/Training/': 1});
//               },
//               child: const Text(
//                 'Start Training',
//                 style: TextStyle(fontSize: 19),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//Works but delete icon not so nice
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:firebase_database/firebase_database.dart';

// class ManageUser extends StatefulWidget {
//   const ManageUser({super.key});

//   @override
//   State<ManageUser> createState() => _ManageUserState();
// }

// class _ManageUserState extends State<ManageUser> {
//   List<String> folders = [];
//   bool isLoading = true;
//   final DatabaseReference database = FirebaseDatabase.instance.ref();
//   String wifiIPAddress = '';
//   String currentIPA = '';

//   @override
//   void initState() {
//     super.initState();
//     setupIPAddressListener();
//   }

//   Future<void> setupIPAddressListener() async {
//     database.child('RaspberryPi/IPAddressRPI/').onValue.listen(
//       (event) {
//         String temp = event.snapshot.value.toString();
//         wifiIPAddress = temp.toString();
//         if (currentIPA != wifiIPAddress) {
//           setState(() {
//             currentIPA = wifiIPAddress;
//             print("CurrentIPA: $currentIPA");
//             fetchFolders();
//           });
//         }
//       },
//     );
//   }

//   Future<void> fetchFolders() async {
//     var url = Uri.parse('http://$currentIPA:5000/list-folders');
//     try {
//       var response = await http.get(url);
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body)['folders'] as List;
//         setState(() {
//           folders = data.cast<String>();
//           isLoading = false;
//         });
//       } else {
//         print('Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   Future<void> deleteFolder(String folderName) async {
//     var url = Uri.parse('http://$currentIPA:5000/delete-folder');
//     try {
//       var response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'folder_name': folderName}),
//       );

//       if (response.statusCode == 200) {
//         fetchFolders(); // Refresh folders list after deletion
//       } else {
//         print('Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text(
//           'Manage User',
//           style: TextStyle(
//               color: Colors.black87, fontSize: 25, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         physics: BouncingScrollPhysics(),
//         child: Center(
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
//                     child: DataTable(
//                       columns: const <DataColumn>[
//                         DataColumn(
//                           label: Text(
//                             'Folders',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         DataColumn(
//                           label: Text(
//                             'Actions',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                       rows: folders
//                           .map(
//                             (folder) => DataRow(
//                               cells: <DataCell>[
//                                 DataCell(
//                                   Text(
//                                     folder,
//                                     style: const TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                                 DataCell(
//                                   IconButton(
//                                     icon: const Icon(Icons.delete,
//                                         color: Colors.white),
//                                     onPressed: () {
//                                       deleteFolder(folder);
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                           .toList(),
//                     ),
//                   ),
//                 ),
//               ),
//               // Other widgets if needed ...
//               SizedBox(
//                 width: 300,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     await database.update({'RaspberryPi/Training/': 1});
//                   },
//                   child: const Text(
//                     'Start Training',
//                     style: TextStyle(fontSize: 19),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

class ManageUser extends StatefulWidget {
  const ManageUser({super.key});

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  List<String> folders = [];
  bool isLoading = true;
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  String wifiIPAddress = '';
  String currentIPA = '';

  @override
  void initState() {
    super.initState();
    setupIPAddressListener();
  }

  Future<void> setupIPAddressListener() async {
    database.child('RaspberryPi/IPAddressRPI/').onValue.listen(
      (event) {
        String temp = event.snapshot.value.toString();
        wifiIPAddress = temp.toString();
        if (currentIPA != wifiIPAddress) {
          setState(() {
            currentIPA = wifiIPAddress;
            print("CurrentIPA: $currentIPA");
            fetchFolders();
          });
        }
      },
    );
  }

  Future<void> fetchFolders() async {
    var url = Uri.parse('http://$currentIPA:5000/list-folders');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['folders'] as List;
        setState(() {
          folders = data.cast<String>();
          isLoading = false;
        });
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteFolder(String folderName) async {
    var url = Uri.parse('http://$currentIPA:5000/delete-folder');
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'folder_name': folderName}),
      );

      if (response.statusCode == 200) {
        fetchFolders(); // Refresh folders list after deletion
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Manage User',
          style: TextStyle(
              color: Colors.black87, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                      height: 10), // Gap between app bar and container
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 106, 95),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Users in the system",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: folders.length,
                            separatorBuilder: (context, index) =>
                                const Divider(color: Colors.white),
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  folders[index],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.white),
                                  onPressed: () {
                                    deleteFolder(folders[index]);
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 350,
                    child: ElevatedButton(
                      onPressed: () async {
                        await database.update({'RaspberryPi/Training/': 1});
                      },
                      child: const Text(
                        'Start Training',
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
