import 'package:flutter/material.dart';
import 'package:mycaleg/services/auth.dart';
import 'package:mycaleg/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:mycaleg/models/pengguna.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyCaleg());
}

class MyCaleg extends StatelessWidget {
  const MyCaleg({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // pengguna
    return StreamProvider<Pengguna>.value(
      value: AuthService().onAuthStateChanges,
      initialData: Pengguna(uid: "", email: ""),
      catchError: (BuildContext context, Object? exception) {
        // print("dari main app");
        return Pengguna(uid: "Pengguna belum sign-in", email: "");
      },
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const Wrapper(),
      ),
    );
  }
}
