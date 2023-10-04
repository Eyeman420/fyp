import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fyp/pages/passcode_update.dart';

class DoorLock extends StatefulWidget {
  const DoorLock({super.key});

  @override
  State<DoorLock> createState() => _DoorLockState();
}

class _DoorLockState extends State<DoorLock> {
  //final FirebaseApp = Firebase.initializeApp();

  int realTimeValue = 0;
  int? currentRTV;
  String lockStatus = '';
  final String imageLock = 'assets/images/lock.png';
  final String imageUnlock = 'assets/images/unlock.png';
  String image = '';
  String IPAdrress = '';
  String currentIPA = '';
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  // final cRed = Colors.red;
  // final cGreen = Colors.green;
  // Object statC = Colors.red;

  @override
  Widget build(BuildContext context) {
    //get DoorState,
    database.child('Door/DoorState/').onValue.listen(
      (event) {
        String temp = event.snapshot.value.toString();
        realTimeValue = int.parse(temp);
        if (realTimeValue != currentRTV) {
          setState(
            () {
              if (realTimeValue == 0) {
                lockStatus = 'Lock';
                image = imageLock;
                // statC = Colors.red;
              } else {
                lockStatus = 'Unlock';
                image = imageUnlock;
                // statC = Colors.green;
              }
              currentRTV = realTimeValue;
            },
          );
        }
      },
    );

    //getIPAddress
    database.child('Door/IPAddressDoor/').onValue.listen(
      (event) {
        String temp = event.snapshot.value.toString();
        IPAdrress = temp.toString();
        if (currentIPA != IPAdrress) {
          setState(
            () {
              currentIPA = IPAdrress;
            },
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Door Lock Systems",
          style: TextStyle(
              color: Colors.black87, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          // /mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),

            // Door Status
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 106, 95),
                borderRadius: BorderRadius.circular(40),
              ),
              child: SizedBox(
                width: 250,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Door Status',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    const SizedBox(height: 6
                        //width: MediaQuery.of(context).size.width,
                        ),
                    Image.asset(image, height: 100),
                    Text(
                      lockStatus,
                      style: const TextStyle(
                          fontSize: 35,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() async {
                          if (realTimeValue == 0) {
                            realTimeValue = 1;
                            image = imageUnlock;
                          } else {
                            realTimeValue = 0;
                            image = imageLock;
                          }
                          await database
                              .update({'Door/DoorState/': realTimeValue});
                        });
                      },
                      child: const Text('Unlock/Lock'),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Door Ip Address
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 106, 95),
                borderRadius: BorderRadius.circular(40),
              ),
              child: SizedBox(
                width: 250,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Door IP Address',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      Text(
                        currentIPA,
                        style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Door Passcode
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 106, 95),
                borderRadius: BorderRadius.circular(40),
              ),
              child: SizedBox(
                width: 250,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Door Passcode Manager',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PasscodeUpdate()),
                            );
                          },
                          child: const Text('Update Passcode')),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),

            // const Text('Door Status',
            //     style: TextStyle(fontSize: 24, color: Colors.white)),
            // SizedBox(
            //   height: 6,
            //   width: MediaQuery.of(context).size.width,
            // ),
            // Image.asset(image, height: 100),
            // ElevatedButton(
            //   onPressed: () {
            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(
            //     //     builder: (context) => ReadExamples(),
            //     //   ),
            //     // );
            //     setState(() async {
            //       if (realTimeValue == 0) {
            //         realTimeValue = 1;
            //         image = imageUnlock;
            //       } else {
            //         realTimeValue = 0;
            //         image = imageLock;
            //       }
            //       await database.update({'Door/DoorState/': realTimeValue});
            //     });
            //   },
            //   child: const Text('Unlock/Lock'),
            // ),
            Text("Realtime data: $realTimeValue"),
            Text('Door Status: $lockStatus')
          ],
        ),
      ),
    );

    // return MaterialApp(
    //   home: Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: Color.fromARGB(255, 0, 106, 95),
    //       title: Text("Door Lock"),
    //       centerTitle: true,
    //     ),
    //     body: Container(
    //       decoration: const BoxDecoration(
    //         gradient: LinearGradient(
    //           colors: [Colors.teal, Colors.tealAccent],
    //           begin: Alignment.topLeft,
    //           end: Alignment.bottomRight,
    //         ),
    //       ),
    //       child: Center(
    //         child: Column(
    //           //column utk setiap container mcm status, button unlock
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Container(
    //               // Status door
    //               decoration: BoxDecoration(
    //                 color: const Color.fromARGB(255, 0, 106, 95),
    //                 borderRadius: BorderRadius.circular(40),
    //               ),
    //               child: SizedBox(
    //                 width: 300,
    //                 child: Column(
    //                   children: [
    //                     const SizedBox(height: 20),
    //                     const Text(
    //                       "Door Lock Status",
    //                       style: TextStyle(fontSize: 24, color: Colors.white),
    //                     ),
    //                     const SizedBox(height: 10),
    //                     Image.asset(image, height: 100),
    //                     const SizedBox(height: 20),
    //                     Text(
    //                       doorStatus,
    //                       style:
    //                           TextStyle(fontSize: 40, color: Colors.redAccent),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 30,
    //             ),
    //             Container(
    //               //Door Control
    //               decoration: BoxDecoration(
    //                 color: const Color.fromARGB(255, 0, 106, 95),
    //                 borderRadius: BorderRadius.circular(40),
    //               ),
    //               width: 300,
    //               child: Container(
    //                 padding: EdgeInsets.all(20),
    //                 //width: 300,
    //                 child: ElevatedButton(
    //                   onPressed: doorActivation,
    //                   style: ElevatedButton.styleFrom(
    //                     backgroundColor: Colors.teal,
    //                     foregroundColor: Colors.white,
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(30),
    //                     ),
    //                   ),
    //                   child: const Text(
    //                     'Unlock/Lock',
    //                     style: TextStyle(fontSize: 20, color: Colors.white),
    //                   ),
    //                 ),
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
