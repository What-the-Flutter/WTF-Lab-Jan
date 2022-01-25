import 'package:firebase_database/firebase_database.dart';

class FirebaseDBProvider {
  final FirebaseDatabase _firebaseDatabase;
  late final DatabaseReference _refPages;
  late final DatabaseReference _refMessages;

  FirebaseDBProvider() : _firebaseDatabase = FirebaseDatabase.instance {
    _refPages = _firebaseDatabase.ref().child('pages');
    _refMessages = _firebaseDatabase.ref().child('messages');
  }

  void addMessage() async {}
}
