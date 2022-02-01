import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import '../../entity/entities.dart';

import '../../main.dart';

class StorageProvider {
  static FirebaseStorage st = FirebaseStorage.instance;

  static Future<Reference> uploadFile(File file, String name) async {
    final ref = await st.ref('$userID/$name');
    await ref.putFile(file);
    return ref;
  }

  static Future<String> getImageUrl(String imageName) async {
    final ref = await st.ref('$userID/$imageName');
    return await ref.getDownloadURL();
  }

  static void deleteAttachedImage(Message message) {
    if (message.imageName != null) {
      st.ref('$userID/${message.imageName}').delete();
    }
  }
}
