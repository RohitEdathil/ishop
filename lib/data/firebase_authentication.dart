import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future signUp(String email, String password) async {
  try {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('loggedIn', true);
    pref.setString('uid', user.user.uid);
    return 'OK';
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 'The password provided is too weak';
    } else if (e.code == 'email-already-in-use') {
      return 'The account already exists for that email';
    } else {
      return 'An error Occured';
    }
  }
}

Future login(String email, String password) async {
  try {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('loggedIn', true);
    pref.setString('uid', user.user.uid);
    return 'OK';
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return 'No user found for that email';
    } else if (e.code == 'wrong-password') {
      return 'Wrong password';
    } else if (e.code == 'invalid-email') {
      return 'Invalid Email';
    } else {
      return 'An error Occured';
    }
  }
}

void logOut() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setBool('loggedIn', false);
  pref.setString('uid', '');
}
