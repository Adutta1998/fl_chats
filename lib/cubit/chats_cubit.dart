import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_notes/services/DatabaseHelper.dart';
import 'package:fl_notes/services/SharedPreferenceHelper.dart';
import 'package:meta/meta.dart';
import 'dart:math';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(ChatsInitial());

  String chatRoomId = "";
  String mName = "", mEmail = "", mPicUrl = "", mUserName = "";

  void initialiseRoom(String username) async {
    mName = await SharedPreferencesHelper().getUserDisplayName();
    mEmail = await SharedPreferencesHelper().getUserEmail();
    mPicUrl = await SharedPreferencesHelper().getUserProfilePictureUrl();
    mUserName = await SharedPreferencesHelper().getUserName();
    chatRoomId = getChatRoomId(mUserName, username);
    checkRoomCreatedOrNot(username).then((value) => {
          DatabaseHelper()
              .getChats(chatRoomId)
              .then((value) => emit(ChatsLoaded(chats: value)))
        });
  }

  Future checkRoomCreatedOrNot(String username) async {
    Map<String, dynamic> roomInfo = {
      "users": [mUserName, username]
    };
    DatabaseHelper().createChatRoom(chatRoomId, roomInfo);
  }

  Future getFromSharedPrefs(String username) async {
    // mName = await SharedPreferencesHelper().getUserDisplayName();
    mEmail = await SharedPreferencesHelper().getUserEmail();
    mPicUrl = await SharedPreferencesHelper().getUserProfilePictureUrl();
    mUserName = await SharedPreferencesHelper().getUserName();
    chatRoomId = getChatRoomId(mUserName, username);
  }

  String getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0))
      return "$a\_$b";
    return "$b\_$a";
  }

  void addMessage(String message) {
    var oldTs = DateTime.now();
    Map<String, dynamic> chat = {
      "message": message,
      "sendBy": mUserName,
      "timestamp": oldTs,
      "picURL": mPicUrl
    };
    var msgid = getRandomString(10);
    DatabaseHelper()
        .addMessage(chatRoomId, chat, msgid)
        .then((val) => _updateLastMessageInfo(chat, mUserName));
  }

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  _updateLastMessageInfo(Map<String, dynamic> chat, String mUserName) {
    Map<String, dynamic> info = {
      "last_message": chat["message"],
      "last_message_ts": chat["timestamp"],
      "last_message_sent_by": mUserName
    };
    DatabaseHelper().updateLastMessageInfo(chatRoomId, info);
  }
}
