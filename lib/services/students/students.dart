import 'package:cloud_firestore/cloud_firestore.dart';

class ParentDatabaseServices {
  final CollectionReference routeCollection = FirebaseFirestore.instance
      .collection("route");

  final CollectionReference studentCollection = FirebaseFirestore.instance
      .collection("student");

  CollectionReference trackingRef = FirebaseFirestore.instance.collection(
    'driver_tracking',
  );

  Future<Map<String, dynamic>?> getStudentById(String studentId) async {
    try {
      DocumentSnapshot studentSnapshot =
          await studentCollection.doc(studentId).get();

      if (studentSnapshot.exists) {
        return studentSnapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching student details: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getRouteById(String routeId) async {
    try {
      DocumentSnapshot routeSnapshot = await routeCollection.doc(routeId).get();

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

  Future<Map<String, dynamic>?> getDriverLocation(String driverId) async {
    try {
      QuerySnapshot querySnapshot = await trackingRef
          .where('driverId', isEqualTo: driverId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching tracking details: $e");
      return null;
    }
  }
}
