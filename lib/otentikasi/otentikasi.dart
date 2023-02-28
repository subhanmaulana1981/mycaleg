import 'package:flutter/material.dart';
import 'package:mycaleg/otentikasi/signin.dart';
import 'package:mycaleg/otentikasi/signup.dart';

class Otentikasi extends StatefulWidget {
  const Otentikasi({Key? key}) : super(key: key);

  @override
  State<Otentikasi> createState() => _OtentikasiState();
}

class _OtentikasiState extends State<Otentikasi> {

  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    // function as properties
    if(showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return SignUp(toggleView: toggleView);
    }
  }
}
