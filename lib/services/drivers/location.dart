import 'package:bus_tracking_app/services/drivers/driver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class LocationServices{
  Future<void> sendLocation(String driverId, LocationData position) async {
    try {
      CollectionReference trackingRef =
      FirebaseFirestore.instance.collection('driver_tracking');

      QuerySnapshot querySnapshot = await trackingRef
          .where('driverId', isEqualTo: driverId)
          .limit(1)
          .get();
      Map<String, dynamic>? routeData = await DriverHomePageDatabaseServices().getRouteByDriverId(driverId);

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        await trackingRef.doc(docId).update({
          'busId': routeData?['busId'],
          'routeId': routeData?['routeId'],
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        await trackingRef.add({
          'driverId': driverId,
          'busId': routeData?['busId'],
          'routeId': routeData?['routeId'],
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("Error updating location: $e");
    }
  }

}