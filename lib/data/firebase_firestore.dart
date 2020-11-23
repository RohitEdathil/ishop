import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> createUser(
    String userName, String shopName, String email) async {
  String response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String uid = pref.getString('uid');
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .set({
        "userName": userName,
        "shopName": shopName,
        "email": email,
      })
      .then((value) => {response = 'OK'})
      .catchError((error) {
        response = "Failed to Signup: $error";
        print(error);
      });
  return response;
}
