import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_notes/services/SharedPreferenceHelper.dart';

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

  Future addMessage(
      String chatRoomID, Map<String, dynamic> chat, String msgid) async {
    return await FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(chatRoomID)
        .collection("chats")
        .doc(msgid)
        .set(chat);
  }

  Future updateLastMessageInfo(
      String chatRoomID, Map<String, dynamic> data) async {
    return await FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(chatRoomID)
        .update(data);
  }

  Future createChatRoom(
      String chatRoomId, Map<String, dynamic> roomInfo) async {
    print("chat room id" + chatRoomId);
    final snapShot = await FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      print("ChatRoomExists");
    } else {
      return await FirebaseFirestore.instance
          .collection("ChatRooms")
          .doc(chatRoomId)
          .set(roomInfo);
    }
  }

  Future<Stream<QuerySnapshot>> getChats(String chatRoomID) async {
    return FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(chatRoomID)
        .collection("chats")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    var myname = await SharedPreferencesHelper().getUserName();
    return FirebaseFirestore.instance
        .collection("ChatRooms")
        .orderBy("last_message_ts", descending: true)
        .where("users", arrayContains: myname)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where("username", isEqualTo: username)
        .get();
  }
}
