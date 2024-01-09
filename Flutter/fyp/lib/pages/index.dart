import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fyp/pages/door_lock.dart';
import 'package:fyp/pages/door_monitor.dart';
import 'package:fyp/pages/motion_sensor.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final items = <Widget>[
    const Icon(Icons.linked_camera_outlined, size: 30),
    const Icon(Icons.home, size: 30),
    const Icon(Icons.directions_run_sharp, size: 30),
  ];

  int index = 1;

  final screens = [
    const DoorMonitor(),
    const DoorLock(),
    const MotionSensor(),
    //StreamDataList(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: IconThemeData(color: Colors.white)),
        child: CurvedNavigationBar(
          items: items,
          backgroundColor: Colors.transparent,
          color: Theme.of(context).colorScheme.inversePrimary,
          buttonBackgroundColor: Theme.of(context).colorScheme.inversePrimary,
          index: index,
          height: 60,
          onTap: (index) => setState(() {
            this.index = index;
          }),
        ),
      ),
    );
  }
}
