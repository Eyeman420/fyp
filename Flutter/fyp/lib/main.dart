import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fyp/pages/door_lock.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fyp/pages/door_monitor.dart';
import 'package:fyp/pages/motion_sensor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)
            .copyWith(background: Colors.teal),
      ),
      home: const myApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class myApp extends StatefulWidget {
  const myApp({super.key});

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: const Text(
      //     "MySafeHouse",
      //     style: TextStyle(
      //         color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      // ),
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
