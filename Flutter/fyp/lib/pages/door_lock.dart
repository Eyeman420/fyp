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
  String image = 'assets/images/lock.png';
  String wifiIPAddress = '';
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
        wifiIPAddress = temp.toString();
        if (currentIPA != wifiIPAddress) {
          setState(
            () {
              currentIPA = wifiIPAddress;
            },
          );
        }
      },
    );

    return Scaffold(
      //extendBody: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Door Lock System",
          style: TextStyle(
              color: Colors.black87, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
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
                          'Passcode Manager',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PasscodeUpdate(),
                                ),
                              );
                            },
                            child: const Text('Update Passcode')),
                        const SizedBox(height: 10),
                      ],
                    ),
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
                          'Wifi IP Address',
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
            ],
          ),
        ),
      ),
    );
  }
}
