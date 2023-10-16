import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class DoorMonitor extends StatefulWidget {
  const DoorMonitor({super.key});

  @override
  State<DoorMonitor> createState() => _DoorMonitorState();
}

class _DoorMonitorState extends State<DoorMonitor> {
  String wifiIPAddress = '';
  VlcPlayerController? _vlcViewController;

  @override
  void initState() {
    super.initState();
    getIpAddressCamera();
  }

  DatabaseReference database = FirebaseDatabase.instance.ref();
  // final VlcPlayerController _vlcViewController =
  //     new VlcPlayerController.network(
  //   "http://192.168.0.15/mjpeg/1",
  //   //wifiIPAddress,
  //   autoPlay: true,
  // );

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

  @override
  Widget build(BuildContext context) {
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
              VlcPlayer(
                controller: _vlcViewController!,
                aspectRatio: 4 / 3,
                //placeholder: Text("Hello World"),
              ),
            // VlcPlayer(
            //   controller: _vlcViewController!,
            //   aspectRatio: 4 / 3,
            //   placeholder: const Text("Hello World"),
            // ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Take picture'),
            ),
          ],
        ),
      ),
    );
  }
}
