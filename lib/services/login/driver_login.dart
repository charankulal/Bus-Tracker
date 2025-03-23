import 'package:cloud_firestore/cloud_firestore.dart';

class DriverLoginDatabaseServices {
  final CollectionReference driverCollection =
  FirebaseFirestore.instance.collection('driver');

  Future<String?> authenticateDriver(String phoneNumber, String password) async {
    try {
      QuerySnapshot querySnapshot = await driverCollection
          .where('phone', isEqualTo: phoneNumber)
          .where('password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      print("Error authenticating driver: $e");
      return null;
    }
  }
}
