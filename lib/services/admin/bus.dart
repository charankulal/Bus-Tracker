import 'package:cloud_firestore/cloud_firestore.dart';

class BusDatabaseMethods {
  final CollectionReference busCollection =
  FirebaseFirestore.instance.collection("bus");

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
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("bus").get();

    return querySnapshot.docs.map((doc) {
      return {
        "busId": doc.id,
        "bus_number": doc["bus_number"],
      };
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
      QuerySnapshot busSnapshot = await FirebaseFirestore.instance.collection("bus").get();
      List<Map<String, dynamic>> allBuses = busSnapshot.docs.map((doc) {
        return {
          "busId": doc.id,
          "bus_number": doc["bus_number"],
        };
      }).toList();

      QuerySnapshot routeSnapshot = await FirebaseFirestore.instance.collection("route").get();
      List<String> assignedBusIds = routeSnapshot.docs
          .map((doc) => doc["busId"] as String)
          .toList();

      List<Map<String, dynamic>> unassociatedBuses = allBuses
          .where((bus) => !assignedBusIds.contains(bus["busId"]))
          .toList();

      return unassociatedBuses;
    } catch (e) {
      print("Error fetching unassociated buses: $e");
      return [];
    }
  }
}
