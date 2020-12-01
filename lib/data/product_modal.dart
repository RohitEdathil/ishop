import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> createProduct(String name, String description, String measure,
    String sellingPrice) async {
  String response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String uid = pref.getString('uid');
  await FirebaseFirestore.instance.collection('products').add({
    "owner": uid,
    "productName": name,
    "description": description,
    "measure": measure,
    "sellingPrice": double.parse(sellingPrice)
  }).then((value) => {response = 'OK'});

  return response;
}
