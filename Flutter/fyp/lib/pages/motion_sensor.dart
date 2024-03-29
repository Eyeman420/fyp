//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fyp/pages/log_motion_sensor.dart';
//import 'package:fyp/pages/stream_data_list.dart';
//import 'package:fyp/pages/passcode_update.dart';

class MotionSensor extends StatefulWidget {
  const MotionSensor({super.key});

  @override
  State<MotionSensor> createState() => _MotionSensorState();
}

class _MotionSensorState extends State<MotionSensor> {
  // int realTimeMotion = 0;
  // int? currentMotion;
  //int motionStatus = 0;
  String wifiIPAddress = '';
  String locationMotion = '';
  bool isSelected = false;
  int motionActive = 0;
  int? currentMA;
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> dataList = [];

  @override
  void initState() {
    super.initState();
  }

  final DatabaseReference database = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
    }

    //getIPAddress
    database.child('MotionSensor/IPAddressMotion/').onValue.listen(
      (event) {
        String temp = event.snapshot.value.toString();
        setState(() {
          wifiIPAddress = temp.toString();
        });
      },
    );

    //getLocationMotion
    database.child('MotionSensor/LocationMotion/').onValue.listen(
      (event) {
        String temp = event.snapshot.value.toString();
        setState(() {
          locationMotion = temp.toString();
        });
      },
    );

    //get MotionActive,
    database.child('MotionSensor/MotionActive/').onValue.listen(
      (event) {
        String temp = event.snapshot.value.toString();

        setState(() {
          motionActive = int.parse(temp);
          if (motionActive == 0) {
            isSelected = false;
          } else {
            isSelected = true;
          }
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Burglary Detection System",
          style: TextStyle(
              color: Colors.black87, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Device list
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 106, 95),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: SizedBox(
                  width: 350,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Device List:',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      ListTile(
                        title: Text(
                          locationMotion,
                          //"Dapur1",
                          style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          wifiIPAddress,
                          //"192.167",
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Switch(
                            onChanged: (isChecked) {
                              setState(() async {
                                // isSelected = !isSelected;
                                isSelected = !isSelected;
                                if (motionActive == 0) {
                                  motionActive = 1;
                                } else {
                                  motionActive = 0;
                                }
                                await database.update({
                                  'MotionSensor/MotionActive/': motionActive
                                });
                              });
                            },
                            value: isSelected,
                            activeColor: Colors.green),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // log
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 106, 95),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: SizedBox(
                  width: 350,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Log Burglary Detection:',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LogMotionSensor(),
                              ),
                            );
                          },
                          child: const Text('Click here'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
