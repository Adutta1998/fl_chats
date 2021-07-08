import 'package:firebase_core/firebase_core.dart';
import 'package:fl_notes/screens/chatrooms_screen.dart';
import 'package:fl_notes/screens/signup_screen.dart';
import 'package:fl_notes/services/AuthService.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: AuthService().getCurrentUser(),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData)
                return ChatRoomScreen();
              else
                return SignupScreen();
            }));
  }
}
