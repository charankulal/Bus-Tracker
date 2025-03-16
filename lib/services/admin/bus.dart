import 'package:cloud_firestore/cloud_firestore.dart';

class BusDatabaseMethods{
  Future addBus(Map<String, dynamic> busInfo) async {
    return await FirebaseFirestore.instance
        .collection("bus")
        .doc()
        .set(busInfo);
  }
}