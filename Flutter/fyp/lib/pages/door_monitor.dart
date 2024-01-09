//CONFIRM WORKING BUT HAVE DELAYS
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

class DoorMonitor extends StatefulWidget {
  const DoorMonitor({super.key});

  @override
  State<DoorMonitor> createState() => _DoorMonitorState();
}

class _DoorMonitorState extends State<DoorMonitor> {
  String wifiIPAddress = '';
  VlcPlayerController? _vlcViewController;
  int flashStatus = 0;
  int currentFlashStatus = 0;
  String flashStatusString = "OFF";

  @override
  void initState() {
    super.initState();
    getIpAddressCamera();
  }

  DatabaseReference database = FirebaseDatabase.instance.ref();
  ScreenshotController screenshotController = ScreenshotController();

  void getIpAddressCamera() {
    database.child('Camera/IPAddressCamera/').onValue.listen(
      (event) {
        String temp = event.snapshot.value.toString();
        setState(() {
          wifiIPAddress = temp.toString();
          // Create a new VlcPlayerController with the updated URL.
          _vlcViewController = VlcPlayerController.network(
            wifiIPAddress,
            autoPlay: true,
            // networkCachingDuration: 0,
            // fileCaching: 0,
            // hardwareAcceleration: false,
          );
        });
      },
    );
  }

  @override
  void dispose() {
    _vlcViewController?.dispose();
    super.dispose();
  }

  SaveToGallery() {
    screenshotController.capture().then((Uint8List? image) {
      saveScreenshot(image!);
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Image saved to gallery')));
  }

  saveScreenshot(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "ScreenShot$time";
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  Future<void> handleFlashStatusToggle() async {
    int newFlashStatus;

    if (currentFlashStatus == 1) {
      newFlashStatus = 0;
      flashStatusString = "OFF";
    } else {
      newFlashStatus = 1;
      flashStatusString = "ON";
    }

    // Update the flash status in the Firebase database
    await database.update({'Camera/Flash': newFlashStatus});

    // Update the state using setState
    setState(() {
      currentFlashStatus = newFlashStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Read current flash value
    database.child('Camera/Flash/').onValue.listen(
      (event) {
        String temp = event.snapshot.value.toString();
        flashStatus = int.parse(temp);
        if (currentFlashStatus != flashStatus) {
          setState(
            () {
              currentFlashStatus = flashStatus;
              if (currentFlashStatus == 0) {
                flashStatusString = "OFF";
              } else {
                flashStatusString = "ON";
              }
            },
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Door Monitoring',
          style: TextStyle(
              color: Colors.black87, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (_vlcViewController != null)
              Screenshot(
                controller: screenshotController,
                child: Container(
                  child: VlcPlayer(
                    controller: _vlcViewController!,
                    aspectRatio: 4 / 3,
                    //placeholder: Text("Hello World"),
                  ),
                ),
              ),
            // VlcPlayer(
            //   controller: _vlcViewController!,
            //   aspectRatio: 4 / 3,
            //   placeholder: const Text("Hello World"),
            // ),
            const SizedBox(height: 20),

            // Button for snap and flash
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              children: [
                SizedBox(
                  width: 190,
                  child: ElevatedButton(
                    onPressed: () {
                      SaveToGallery();
                    },
                    child: const Text('Take a picture'),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 190,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(
                        () async {
// Call a separate async function to handle the button press
                          await handleFlashStatusToggle();
                        },
                      );
                    },
                    child: const Text('Turn Flash ON/OFF'),
                  ),
                  //   onPressed: () {
                  //     setState(() async {
                  //       if (currentFlashStatus == 1) {
                  //         currentFlashStatus = 0;
                  //         flashStatusString = "OFF";

                  //       } else {
                  //         currentFlashStatus = 1;
                  //         flashStatusString = "ON";
                  //       }

                  //       await database
                  //           .update({'Camera/Flash': currentFlashStatus});
                  //     });
                  //   },
                  //   child: const Text('Turn Flash ON/OFF'),
                  // ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),

            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 106, 95),
                borderRadius: BorderRadius.circular(40),
              ),
              child: SizedBox(
                width: 250,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        "Flash Status: ",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        flashStatusString,
                        style: const TextStyle(
                            fontSize: 35,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'dart:typed_data';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:screenshot/screenshot.dart';

// class DoorMonitor extends StatefulWidget {
//   const DoorMonitor({super.key});

//   @override
//   State<DoorMonitor> createState() => _DoorMonitorState();
// }

// class _DoorMonitorState extends State<DoorMonitor> {
//   String wifiIPAddress = '';
//   VlcPlayerController? _vlcViewController;

//   @override
//   void initState() {
//     super.initState();
//     getIpAddressCamera();
//   }

//   DatabaseReference database = FirebaseDatabase.instance.reference();
//   ScreenshotController screenshotController = ScreenshotController();

//   void getIpAddressCamera() {
//     database.child('Camera/IPAddressCamera/').onValue.listen(
//       (event) {
//         String temp = event.snapshot.value.toString();
//         setState(() {
//           wifiIPAddress = temp.toString();
//         });
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _vlcViewController?.dispose();
//     super.dispose();
//   }

//   void saveScreenshot(Uint8List bytes) async {
//     final time = DateTime.now()
//         .toIso8601String()
//         .replaceAll('.', '-')
//         .replaceAll(':', '-');
//     final name = "ScreenShot$time";
//     await ImageGallerySaver.saveImage(bytes, name: name);
//   }

//   void takeScreenshot() {
//     screenshotController.capture().then((Uint8List? image) {
//       if (image != null) {
//         saveScreenshot(image);
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text('Image saved to gallery')));
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text(
//           'Door Monitoring',
//           style: TextStyle(
//             color: Colors.black87,
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             if (_vlcViewController != null)
//               Screenshot(
//                 controller: screenshotController,
//                 child: Container(
//                   child: VlcPlayer(
//                     controller: _vlcViewController!,
//                     aspectRatio: 4 / 3,
//                     placeholder: Center(child: CircularProgressIndicator()),
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: takeScreenshot,
//               child: const Text('Take picture'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';

// class DoorMonitor extends StatefulWidget {
//   const DoorMonitor({super.key});

//   @override
//   State<DoorMonitor> createState() => _DoorMonitorState();
// }

// class _DoorMonitorState extends State<DoorMonitor> {
//   String wifiIPAddress = '';
//   VlcPlayerController? _vlcViewController;

//   @override
//   void initState() {
//     super.initState();
//     getIpAddressCamera();
//   }

//   DatabaseReference database = FirebaseDatabase.instance.ref();
//   // final VlcPlayerController _vlcViewController =
//   //     new VlcPlayerController.network(
//   //   "http://192.168.0.15/mjpeg/1",
//   //   //wifiIPAddress,
//   //   autoPlay: true,
//   // );

//   void getIpAddressCamera() {
//     database.child('Camera/IPAddressCamera/').onValue.listen(
//       (event) {
//         String temp = event.snapshot.value.toString();
//         setState(() {
//           wifiIPAddress = temp.toString();
//           // Create a new VlcPlayerController with the updated URL.
//           _vlcViewController = VlcPlayerController.network(
//             wifiIPAddress,
//             autoPlay: true,
//             // networkCachingDuration: 0,
//             // fileCaching: 0,
//             // hardwareAcceleration: false,
//           );
//         });
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _vlcViewController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text(
//           'Door Monitoring',
//           style: TextStyle(
//               color: Colors.black87, fontSize: 25, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             if (_vlcViewController != null)
//               VlcPlayer(
//                 controller: _vlcViewController!,
//                 aspectRatio: 4 / 3,
//                 //placeholder: Text("Hello World"),
//               ),
//             // VlcPlayer(
//             //   controller: _vlcViewController!,
//             //   aspectRatio: 4 / 3,
//             //   placeholder: const Text("Hello World"),
//             // ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {},
//               child: const Text('Take picture'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
