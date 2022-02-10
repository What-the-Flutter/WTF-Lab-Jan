import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static Future<UploadTask?> uploadFile(String destination, File file) async {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      await ref.putFile(file);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static UploadTask? deleteFile(String destination) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      ref.delete();
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String> getFile(String destination) async {
    final downloadURL =
        await FirebaseStorage.instance.ref(destination).getDownloadURL();

    return downloadURL;
  }
}
