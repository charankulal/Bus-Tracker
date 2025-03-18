import 'package:cloud_firestore/cloud_firestore.dart';

class DriverDatabaseServices {
  final CollectionReference driverCollection = FirebaseFirestore.instance
      .collection("driver");

  Future<void> addDriver(Map<String, dynamic> driverInfo) async {
    DocumentReference docRef = driverCollection.doc();
    String driverId = docRef.id;

    driverInfo['driverId'] = driverId;

    await docRef.set(driverInfo);
  }

  Future<Stream<QuerySnapshot>> getAllDrivers() async {
    return driverCollection.snapshots();
  }

  Future updateDriver(String id, Map<String, dynamic> updateInfo) async {
    return await driverCollection.doc(id).update(updateInfo);
  }

  Future deleteDriver(String driverId) async {
    return await driverCollection.doc(driverId).delete();
  }
}
