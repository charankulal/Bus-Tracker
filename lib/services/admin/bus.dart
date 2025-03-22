import 'package:cloud_firestore/cloud_firestore.dart';

class BusDatabaseMethods {
  final CollectionReference busCollection = FirebaseFirestore.instance
      .collection("bus");

  Future<void> addBus(Map<String, dynamic> busInfo) async {
    DocumentReference docRef = busCollection.doc();
    String busId = docRef.id;

    busInfo['busId'] = busId;

    await docRef.set(busInfo);
  }

  Future<Stream<QuerySnapshot>> getAllBuses() async {
    return busCollection.snapshots();
  }

  Future updateBus(String id, Map<String, dynamic> updateInfo) async {
    return await busCollection.doc(id).update(updateInfo);
  }

  Future deleteBus(String busId) async {
    return await busCollection.doc(busId).delete();
  }

  Future<List<Map<String, dynamic>>> getAllBusIDNumber() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("bus").get();

    return querySnapshot.docs.map((doc) {
      return {"busId": doc.id, "bus_number": doc["bus_number"]};
    }).toList();
  }

  Future<String> getBusNumberById(String busId) async {
    try {
      DocumentSnapshot busSnapshot = await busCollection.doc(busId).get();
      if (busSnapshot.exists) {
        return busSnapshot["bus_number"] ?? "Unknown";
      } else {
        return "Not Found";
      }
    } catch (e) {
      print("Error fetching bus details: $e");
      return "Error";
    }
  }

  Future<List<Map<String, dynamic>>> getUnassociatedBuses() async {
    try {
      QuerySnapshot busSnapshot =
          await FirebaseFirestore.instance.collection("bus").get();
      List<Map<String, dynamic>> allBuses =
          busSnapshot.docs.map((doc) {
            return {"busId": doc.id, "bus_number": doc["bus_number"]};
          }).toList();

      QuerySnapshot routeSnapshot =
          await FirebaseFirestore.instance.collection("route").get();
      List<String> assignedBusIds =
          routeSnapshot.docs.map((doc) => doc["busId"] as String).toList();

      List<Map<String, dynamic>> unassociatedBuses =
          allBuses
              .where((bus) => !assignedBusIds.contains(bus["busId"]))
              .toList();

      return unassociatedBuses;
    } catch (e) {
      print("Error fetching unassociated buses: $e");
      return [];
    }
  }

  final CollectionReference routeCollection = FirebaseFirestore.instance
      .collection('route');

  Future<String?> getRouteNameByBusId(String busId) async {
    try {
      QuerySnapshot querySnapshot =
          await routeCollection.where('busId', isEqualTo: busId).get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['route_name'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching route name: $e");
      return null;
    }
  }
  final CollectionReference driverCollection = FirebaseFirestore.instance
      .collection('driver');

  Future<Map<String, String?>?> getDriverDetailsByBusId(String busId) async {
    try {
      QuerySnapshot routeSnapshot =
      await routeCollection.where('busId', isEqualTo: busId).get();

      if (routeSnapshot.docs.isEmpty) {
        return null;
      }

      String driverId = routeSnapshot.docs.first['driverId'];
      DocumentSnapshot driverSnapshot = await driverCollection.doc(driverId).get();

      if (!driverSnapshot.exists) {
        return null;
      }

      String? driverName = driverSnapshot['name'] as String?;
      String? driverPhone = driverSnapshot['phone'] as String?;

      return {
        'name': driverName,
        'phone': driverPhone,
      };
    } catch (e) {
      print("Error fetching driver details: $e");
      return null;
    }
  }

  Future<int> getTotalBuses() async {
    try {
      QuerySnapshot querySnapshot = await busCollection.get();
      return querySnapshot.docs.length;
    } catch (e) {
      print("Error fetching total buses: $e");
      return 0;
    }
  }
}
