import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_notes/screens/chatrooms_screen.dart';
import 'package:fl_notes/services/DatabaseHelper.dart';
import 'package:fl_notes/services/SharedPreferenceHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return auth.currentUser;
  }

  signIn(BuildContext context) async {
    final _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication _authentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: _authentication.idToken,
        accessToken: _authentication.accessToken);

    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    User user = userCredential.user!;

    // ignore: unnecessary_null_comparison
    if (userCredential != null) {
      SharedPreferencesHelper().saveUserId(user.uid);
      SharedPreferencesHelper().saveUserDisplayName(user.displayName!);
      SharedPreferencesHelper().saveUserEmail(user.email!);
      SharedPreferencesHelper().saveUserProfilePictureUrl(user.photoURL!);
      SharedPreferencesHelper()
          .saveUserName(user.email!.replaceAll("@gmail.com", ""));

      Map<String, dynamic> userMap = {
        "email": user.email,
        "username": user.email!.replaceAll("@gmail.com", ""),
        "name": user.displayName,
        "imageURL": user.photoURL
      };
      DatabaseHelper().saveUser(user.uid, userMap).then((value) => {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => ChatRooms()))
          });
    }
  }

  Future signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    return auth.signOut();
  }
}
