import 'package:cloud_firestore/cloud_firestore.dart';

class DriverHomePageDatabaseServices {
  final CollectionReference routeCollection =
  FirebaseFirestore.instance.collection('route');

  final CollectionReference busCollection =
  FirebaseFirestore.instance.collection('bus');

  Future<Map<String, dynamic>?> getRouteByDriverId(String driverId) async {
    try {
      QuerySnapshot querySnapshot = await routeCollection
          .where('driverId', isEqualTo: driverId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching route details: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getBusByBusId(String busId) async {
    try {
      QuerySnapshot querySnapshot = await busCollection
          .where('busId', isEqualTo: busId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching route details: $e");
      return null;
    }
  }
}
