import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class DoorMonitor extends StatefulWidget {
  const DoorMonitor({super.key});

  @override
  State<DoorMonitor> createState() => _DoorMonitorState();
}

class _DoorMonitorState extends State<DoorMonitor> {
  VlcPlayerController _vlcViewController = new VlcPlayerController.network(
    "http://192.168.0.5/mjpeg/1",
    autoPlay: true,
  );

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
            new VlcPlayer(
              controller: _vlcViewController,
              aspectRatio: 4 / 3,
              placeholder: Text("Hello World"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Take picture'),
            ),
          ],
        ),
      ),
    );
  }
}
