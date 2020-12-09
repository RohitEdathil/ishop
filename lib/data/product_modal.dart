import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ishop/data/firebase_image_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> createProduct(String name, String description, String measure,
    String sellingPrice, String productImagePath) async {
  String response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String uid = pref.getString('uid');
  String imageName = "$uid${DateTime.now().toString()}.png";
  await FirebaseFirestore.instance.collection('products').add({
    "owner": uid,
    "productName": name,
    "description": description,
    "measure": measure,
    "sellingPrice": double.parse(sellingPrice),
    "imageName": productImagePath != null ? imageName : ""
  }).then((value) async {
    bool uploaded = productImagePath != null
        ? await uploadFile(productImagePath, "productImages/$imageName.png")
        : true;
    if (uploaded) {
      response = "OK";
    }
  });

  return response;
}
