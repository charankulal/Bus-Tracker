import 'package:cloud_firestore/cloud_firestore.dart';

class AdminLoginServices {
  final CollectionReference adminPasswordCollection =
  FirebaseFirestore.instance.collection("admin");

  Future<List<String>> getAllAdminPasswords() async {
    try {
      QuerySnapshot querySnapshot = await adminPasswordCollection.get();
      List<String> passwords = querySnapshot.docs
          .map((doc) => doc.get('password').toString()) // Ensure 'password' exists
          .toList();
      return passwords;
    } catch (e) {
      print("Error fetching admin passwords: $e");
      return [];
    }
  }
}
