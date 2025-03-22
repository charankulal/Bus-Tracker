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

  Future<List<Map<String, dynamic>>> getAllDriversIDName() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("driver").get();

    return querySnapshot.docs.map((doc) {
      return {
        "driverId": doc.id,
        "name": doc["name"],
      };
    }).toList();
  }

  Future<String> getDriverNameById(String driverId) async {
    try {
      DocumentSnapshot driverSnapshot = await driverCollection.doc(driverId).get();
      if (driverSnapshot.exists) {
        return driverSnapshot["name"] ?? "Unknown";
      } else {
        return "Not Found";
      }
    } catch (e) {
      print("Error fetching bus details: $e");
      return "Error";
    }
  }

  Future<String> getDriverPhoneById(String driverId) async {
    try {
      DocumentSnapshot driverSnapshot = await driverCollection.doc(driverId).get();
      if (driverSnapshot.exists) {
        return driverSnapshot["phone"] ?? "Unknown";
      } else {
        return "Not Found";
      }
    } catch (e) {
      print("Error fetching bus details: $e");
      return "Error";
    }
  }
  Future<List<Map<String, dynamic>>> getUnassociatedDrivers() async {
    try {
      QuerySnapshot driverSnapshot = await FirebaseFirestore.instance.collection("driver").get();
      List<Map<String, dynamic>> allDrivers = driverSnapshot.docs.map((doc) {
        return {
          "driverId": doc.id,
          "name": doc["name"],
        };
      }).toList();

      QuerySnapshot routeSnapshot = await FirebaseFirestore.instance.collection("route").get();
      List<String> assignDriverIds = routeSnapshot.docs
          .map((doc) => doc["driverId"] as String)
          .toList();

      List<Map<String, dynamic>> unassociatedDrivers = allDrivers
          .where((driver) => !assignDriverIds.contains(driver["driverId"]))
          .toList();

      return unassociatedDrivers;
    } catch (e) {
      print("Error fetching unassociated drivers: $e");
      return [];
    }
  }

}
