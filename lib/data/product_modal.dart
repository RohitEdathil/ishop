import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ishop/data/firebase_image_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> createProduct(String name, String description, String measure,
    String sellingPrice, String productImagePath) async {
  String response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String uid = pref.getString('uid');
  String imageName = "$uid${DateTime.now().toString()}";
  await FirebaseFirestore.instance.collection('products').add({
    "owner": uid,
    "productName": name,
    "description": description,
    "measure": measure,
    "sellingPrice": double.parse(sellingPrice),
    "createdOn": DateTime.now(),
    "imageName": productImagePath != null ? imageName : ""
  }).then((value) async {
    bool uploaded = productImagePath != null
        ? await uploadFile(productImagePath, "productImages/$imageName")
        : true;
    if (uploaded) {
      response = "OK";
    }
  });

  return response;
}

Future<QuerySnapshot> getProductList() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String uid = pref.getString('uid');
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  final snapshot = await products.where('owner', isEqualTo: uid).get();

  return snapshot;
}

Future<DocumentSnapshot> getProductById(id) async {
  final result =
      await FirebaseFirestore.instance.collection('products').doc(id).get();
  return result;
}
