import 'package:fl_notes/services/AuthService.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            AuthService().signIn(context);
          },
          icon: Icon(Icons.login),
          label: Text("SIgnup With Google"),
        ),
      ),
    );
  }
}
