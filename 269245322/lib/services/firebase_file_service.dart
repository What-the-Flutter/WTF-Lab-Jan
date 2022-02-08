import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UploadTask> uploadFile(String destination, File file) async {
    final ref = FirebaseStorage.instance.ref(destination);
    return ref.putFile(file);
  }
}
