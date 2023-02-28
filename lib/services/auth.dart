import 'package:firebase_auth/firebase_auth.dart';
import 'package:mycaleg/models/pengguna.dart';
import 'package:mycaleg/services/database.dart';

class AuthService {
  // instance dari firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on firebase user
  Pengguna? _userFromFirebaseUser(User? user) {
    try {
      return (user != null)
          ? Pengguna(
              uid: user.uid,
              email: user.email.toString(),
            )
          : null;
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  // auth change user stream
  Stream<Pengguna>? get onAuthStateChanges {
    try {
      return _auth
          .authStateChanges()
          .map((User? user) => _userFromFirebaseUser(user)!);
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  // sign in anonymously
  Future<dynamic> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return (user!);
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future<dynamic> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return _userFromFirebaseUser(user!);
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future<dynamic> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      // firebase authentication result
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // firebase user
      User? user = result.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user!.uid).setCalegData(
          user.uid,
          "pan",
          "1",
          "tambun selatan",
          "new caleg"
      );

      // our custom user
      return _userFromFirebaseUser(user);
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  // sign out
  Future<dynamic> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

}
