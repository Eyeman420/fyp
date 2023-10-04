import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PasscodeUpdate extends StatefulWidget {
  const PasscodeUpdate({super.key});

  @override
  State<PasscodeUpdate> createState() => _PasscodeUpdateState();
}

class _PasscodeUpdateState extends State<PasscodeUpdate> {
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  String passcode = '';
  String currentPasscode = '';
  final _textController = TextEditingController();
  String updatedPasscord = '';

  @override
  Widget build(BuildContext context) {
    //getPasscode
    database.child('Door/Passcode/').onValue.listen(
      (event) {
        String temp = event.snapshot.value.toString();
        passcode = temp.toString();
        if (currentPasscode != passcode) {
          setState(
            () {
              currentPasscode = passcode;
            },
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Update Door Passcode',
          style: TextStyle(
              color: Colors.black87, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Current Passcode: ',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            currentPasscode,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.red),
                          ),
                        ],
                      ),
                      const Text('Enter the new Passcode:',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: '4 to 6 Characters',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _textController.clear();
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() async {
                            updatedPasscord = _textController.text;
                            await database
                                .update({'Door/Passcode/': updatedPasscord});
                          });
                        },
                        child: Text('Update'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 106, 95),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const SizedBox(
                width: 350,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'After update the Passcode,\nPlease press the UPDATE button on Door Lock System.',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
