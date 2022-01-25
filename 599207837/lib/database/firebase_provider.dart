import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import '../entity/entities.dart';
import '../main.dart';

class FireBaseProvider {
  static FirebaseFirestore fb = FirebaseFirestore.instance;

  static Future<void> initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  static void newTopic(Topic newTopic) => fb.collection('Topics').add(newTopic.toJson());

  static void deleteTopic(Topic topic) {
    deleteAllMessages(topic);
    fb.collection('Topics').doc(topic.nodeID).delete();
  }

  static void updateTopic(Topic topic) =>
      fb.collection('Topics').doc(topic.nodeID).update(topic.toJson());

  static Future<Message> getLastMessage(Topic topic) async {
    Message? ret;
    await fb
        .collection('Messages')
        .where('uid', isEqualTo: userID)
        .where('topic_id', isEqualTo: topic.id)
        .orderBy('time_created')
        .get()
        .then((querySnapshot) {
      ret = Message.fromJson(querySnapshot.docs.last.data(), topic,
          nodeID: querySnapshot.docs.last.id);
    });
    return ret!;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getTopics() =>
      fb.collection('Topics').where('uid', isEqualTo: userID).snapshots();

  static void newMessage(Message newMessage) => fb.collection('Messages').add(newMessage.toJson());

  static Stream<QuerySnapshot<Map<String, dynamic>>> getTopicMessages(Topic topic) => fb
      .collection('Messages')
      .where('uid', isEqualTo: userID)
      .where('topic_id', isEqualTo: topic.id)
      .orderBy('time_created', descending: true)
      .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> loadTypeFavourites(int typeID) => fb
      .collection('Messages')
      .where('uid', isEqualTo: userID)
      .where('type_id', isEqualTo: typeID)
      .snapshots();

  static void deleteMessage(Message o) => fb.collection('Messages').doc(o.nodeID).delete();

  static void updateMessage(Message o) =>
      fb.collection('Messages').doc(o.nodeID).update(o.toJson());

  static void deleteAllMessages(Topic topic) async {
    fb.collection('Messages').where('topic_id', isEqualTo: topic.id).get().then(
      (querySnapshot) {
        for (var doc in querySnapshot.docs) {
          fb.collection('Messages').doc(doc.id).delete();
        }
      },
    );
  }
}
