import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {
  Future saveUser(String userId, Map<String, dynamic> user) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .set(user);
  }

  Future<Stream<QuerySnapshot>> getUserByUsername(String username) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .where("username", isEqualTo: username)
        .snapshots();
  }
}
