import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreProvider {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('event_images');

  Future<void> addImageEvent(String eventId, String imagePath) async {
    final imageMap = <String, dynamic>{'image_path': imagePath};
    collection.doc(eventId).set(imageMap);
  }
}
