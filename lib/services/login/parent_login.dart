import 'package:cloud_firestore/cloud_firestore.dart';

class StudentLoginDatabaseServices {
  final CollectionReference studentCollection =
  FirebaseFirestore.instance.collection('student');

  Future<String?> authenticateParent(String phoneNumber, String password) async {
    try {
      QuerySnapshot querySnapshot = await studentCollection
          .where('phone', isEqualTo: phoneNumber)
          .where('password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      print("Error authenticating student: $e");
      return null;
    }
  }
}
