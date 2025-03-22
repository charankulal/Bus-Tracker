import 'package:cloud_firestore/cloud_firestore.dart';

class StudentsDatabaseServices {
  final CollectionReference studentCollection = FirebaseFirestore.instance
      .collection("student");

  Future<void> addStudent(Map<String, dynamic> studentInfo) async {
    DocumentReference docRef = studentCollection.doc();
    String studentId = docRef.id;

    studentInfo['studentId'] = studentId;

    await docRef.set(studentInfo);
  }

  Future<Stream<QuerySnapshot>> getAllStudents() async {
    return studentCollection.snapshots();
  }

  Future<List<Map<String, dynamic>>> getAllRoutesIDName() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("route").get();

    return querySnapshot.docs.map((doc) {
      return {"routeId": doc.id, "route_name": doc["route_name"]};
    }).toList();
  }

  Future<Map<String, dynamic>?> getStudentById(String studentId) async {
    try {
      DocumentSnapshot routeSnapshot =
      await studentCollection.doc(studentId).get();

      if (routeSnapshot.exists) {
        return routeSnapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching student details: $e");
      return null;
    }
  }

  Future updateStudent(String id, Map<String, dynamic> updateInfo) async {
    return await studentCollection.doc(id).update(updateInfo);
  }
}
