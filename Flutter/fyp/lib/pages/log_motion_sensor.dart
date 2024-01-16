//

// Working but not very nice
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

// class LogMotionSensor extends StatefulWidget {
//   const LogMotionSensor({Key? key}) : super(key: key);

//   @override
//   State<LogMotionSensor> createState() => _LogMotionSensorState();
// }

// class _LogMotionSensorState extends State<LogMotionSensor> {
//   final database = FirebaseDatabase.instance.reference();
//   List<String> logs = [];

//   @override
//   void initState() {
//     super.initState();
//     // Fetch logs from Firebase RTDB
//     fetchLogs();
//   }

//   void fetchLogs() {
//     database.child('Logs').once().then((DatabaseEvent event) {
//       DataSnapshot? snapshot = event.snapshot;
//       if (snapshot != null) {
//         var value = snapshot.value;
//         if (value is List<dynamic> || value == null) {
//           List<dynamic>? logList = value as List<dynamic>?;
//           if (logList != null) {
//             for (var logEntry in logList) {
//               logs.add(logEntry.toString());
//             }
//             // Update UI after fetching logs
//             setState(() {});
//           } else {
//             // Handle the case when the value cannot be cast to List<dynamic>
//             print("Failed to cast snapshot value to List");
//           }
//         } else if (value is Map<dynamic, dynamic>) {
//           // Handle the case when the value is a Map<dynamic, dynamic>
//           print("Snapshot value is a Map, not a List");
//         } else {
//           // Handle the case when the value is of unexpected type
//           print("Snapshot value is of unexpected type: ${value.runtimeType}");
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         title: const Text(
//           'Logs Motion Sensor',
//           style: TextStyle(
//             color: Colors.black87,
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: ListView.builder(
//         itemCount: logs.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(logs[index]),
//           );
//         },
//       ),
//     );
//   }
// }

// Kemas but somtimes failed to get logs
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

// class LogMotionSensor extends StatefulWidget {
//   const LogMotionSensor({Key? key}) : super(key: key);

//   @override
//   State<LogMotionSensor> createState() => _LogMotionSensorState();
// }

// class _LogMotionSensorState extends State<LogMotionSensor> {
//   final database = FirebaseDatabase.instance.reference();
//   List<String> logs = [];

//   @override
//   void initState() {
//     super.initState();
//     // Fetch logs from Firebase RTDB
//     fetchLogs();
//   }

//   void fetchLogs() {
//     database.child('Logs').once().then((DatabaseEvent event) {
//       DataSnapshot? snapshot = event.snapshot;
//       if (snapshot != null) {
//         var value = snapshot.value;
//         if (value is List<dynamic> || value == null) {
//           List<dynamic>? logList = value as List<dynamic>?;
//           if (logList != null) {
//             for (var logEntry in logList) {
//               logs.add(logEntry.toString());
//             }
//             // Update UI after fetching logs
//             setState(() {});
//           } else {
//             // Handle the case when the value cannot be cast to List<dynamic>
//             print("Failed to cast snapshot value to List");
//           }
//         } else if (value is Map<dynamic, dynamic>) {
//           // Handle the case when the value is a Map<dynamic, dynamic>
//           print("Snapshot value is a Map, not a List");
//         } else {
//           // Handle the case when the value is of unexpected type
//           print("Snapshot value is of unexpected type: ${value.runtimeType}");
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         title: const Text(
//           'Logs Motion Sensor',
//           style: TextStyle(
//             color: Colors.black87,
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: DataTable(
//           columns: const <DataColumn>[
//             DataColumn(label: Text('Logs')),
//           ],
//           rows: logs
//               .map(
//                 (log) => DataRow(
//                   cells: <DataCell>[
//                     DataCell(Text(log)),
//                   ],
//                 ),
//               )
//               .toList(),
//         ),
//       ),
//     );
//   }
// }

//Working code
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class LogMotionSensor extends StatefulWidget {
  const LogMotionSensor({Key? key}) : super(key: key);

  @override
  State<LogMotionSensor> createState() => _LogMotionSensorState();
}

class _LogMotionSensorState extends State<LogMotionSensor> {
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  List<String> logs = [];

  @override
  void initState() {
    super.initState();
    // Fetch logs from Firebase RTDB
    fetchLogs();
  }

  void fetchLogs() {
    database.child('Logs').once().then((DatabaseEvent event) {
      DataSnapshot? snapshot = event.snapshot;
      if (snapshot != null) {
        var value = snapshot.value;
        if (value is List<Object?>) {
          // Handle List<Object?>
          List<Object?>? logList = value;
          if (logList != null) {
            for (var logEntry in logList) {
              logs.add(logEntry.toString());
            }
            // Update UI after fetching logs
            setState(() {});
          } else {
            // Handle the case when the value is null
            print("Snapshot value is null");
          }
        } else {
          // Handle the case when the value is of unexpected type
          print("Snapshot value is of unexpected type: ${value.runtimeType}");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Logs Motion Sensor',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 106, 95),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: SizedBox(
                  width: 350,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Logs',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: logs
                          .map(
                            (log) => DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text(
                                    log,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
