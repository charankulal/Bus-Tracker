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
}
