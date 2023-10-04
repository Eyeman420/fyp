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
        title: Text("Monitor"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new VlcPlayer(
              controller: _vlcViewController,
              aspectRatio: 16 / 9,
              placeholder: Text("Hello World"),
            ),
          ],
        ),
      ),
    );
  }
}
