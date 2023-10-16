import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  // CReate instance FBM
  final _firebaseMessaging = FirebaseMessaging.instance;
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();

    print('Token: $fCMToken');
    await database.update({'SmartPhone/Token/': fCMToken});
  }
}
