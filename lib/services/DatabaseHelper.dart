import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {
  Future saveUser(String userId, Map<String, dynamic> user) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .set(user);
  }
}
