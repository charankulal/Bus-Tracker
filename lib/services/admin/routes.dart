import 'package:cloud_firestore/cloud_firestore.dart';

class RoutesDatabaseService{
  final CollectionReference routeCollection = FirebaseFirestore.instance
      .collection("route");

  Future<void> addRoute(Map<String, dynamic> routeInfo) async {
    DocumentReference docRef = routeCollection.doc();
    String routeId = docRef.id;

    routeInfo['routeId'] = routeId;

    await docRef.set(routeInfo);
  }

  Future updateRoute(String id, Map<String, dynamic> updateInfo) async {
    return await routeCollection.doc(id).update(updateInfo);
  }

  Future<Stream<QuerySnapshot>> getAllRoutes() async {
    return routeCollection.snapshots();
  }

  Future<Map<String, dynamic>?> getRouteById(String routeId) async {
    try {
      DocumentSnapshot routeSnapshot =
      await routeCollection.doc(routeId).get();

      if (routeSnapshot.exists) {
        return routeSnapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching route details: $e");
      return null;
    }
  }

  Future deleteRoute(String routeId) async {
    return await routeCollection.doc(routeId).delete();
  }

}