import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

Future<bool> uploadFile(String filePath, String serverPath) async {
  File file = File(filePath);

  try {
    await firebase_storage.FirebaseStorage.instance
        .ref(serverPath)
        .putFile(file);
    return true;
  } on firebase_core.FirebaseException catch (e) {
    print(e.code);
    return false;
  }
}

Future<String> getPhoto(name, category) async {
  return await firebase_storage.FirebaseStorage.instance
      .ref('$category/$name')
      .getDownloadURL();
}
