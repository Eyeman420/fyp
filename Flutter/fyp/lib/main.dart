// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'FCM Push Notification',
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   @override
//   void initState() {
//     super.initState();

//     // Register the background message handler.
//     FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

//     _configureFirebaseMessaging();
//   }

//   void _configureFirebaseMessaging() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       final notification = message.notification;
//       final data = message.data;

//       final title = notification?.title ?? "Default Title";
//       final body = notification?.body ?? "Default Body";

//       print("Received message - Title: $title, Body: $body");

//       // Display the notification using fluttertoast.
//       Fluttertoast.showToast(
//         msg: "$title: $body",
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 5,
//         backgroundColor: Colors.blue,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//     });
//   }

//   Future<void> _backgroundHandler(RemoteMessage message) async {
//     final notification = message.notification;
//     final data = message.data;

//     final title = notification?.title ?? "Default Title";
//     final body = notification?.body ?? "Default Body";

//     print("Handling a background message - Title: $title, Body: $body");

//     // Handle the background message here.
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('FCM Push Notification'),
//       ),
//       body: Center(
//         child: Text('Push Notification Example'),
//       ),
//     );
//   }
// }

// CODING FYP
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/api/firebase_api.dart';
import 'package:fyp/pages/stream_data_list.dart';
import 'package:fyp/pages/door_lock.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fyp/pages/door_monitor.dart';
import 'package:fyp/pages/motion_sensor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  //FirebaseAnalytics().logAppOpen();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //MyApp({super.key});

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    //super.initState();

    // Register the background message handler.
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    _configureFirebaseMessaging();
  }

  // Code ni broken lagi
  void _configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final data = message.data;

      final title = notification?.title ?? "Default Title";
      final body = notification?.body ?? "Default Body";

      print("Received message - Title: $title, Body: $body");

      // Display the notification using fluttertoast.
      Fluttertoast.showToast(
        msg: "$title: $body",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  Future<void> _backgroundHandler(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    final title = notification?.title ?? "Default Title";
    final body = notification?.body ?? "Default Body";

    print("Handling a background message - Title: $title, Body: $body");

    // Handle the background message here.
  }

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
    //StreamDataList(),
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


// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:fyp/api/firebase_api.dart';
// import 'package:fyp/firebase_options.dart';
// import 'package:fyp/pages/home_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await FirebaseApi().initNotifications();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

//Firestore Read logs
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: FirestoreExample(),
//     );
//   }
// }

// class FirestoreExample extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firestore Example'),
//       ),
//       body: StreamDataList(),
//     );
//   }
// }

// class StreamDataList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('LogMotion').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }

//         List<String> dataList = snapshot.data!.docs.map((doc) {
//           final data = doc.data() as Map<String, dynamic>;
//           return data['Message'].toString();
//         }).toList();

//         return dataList.isEmpty
//             ? Text('No data available.')
//             : ListView.builder(
//                 itemCount: dataList.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(dataList[index]),
//                   );
//                 },
//               );
//       },
//     );
//   }
// }
