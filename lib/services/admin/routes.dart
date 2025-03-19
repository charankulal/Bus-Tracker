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
}