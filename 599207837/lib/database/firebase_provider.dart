import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import '../entity/entities.dart';
import '../main.dart';

class FireBaseProvider {
  static FirebaseDatabase fb = FirebaseDatabase.instance;

  static Future<void> initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  static void newTopic(Topic newTopic) => fb.ref('topics/${newTopic.id}').set(newTopic.toJson());

  static void deleteTopic(Topic topic) {
    deleteAllMessages(topic);
    fb.ref('topics/${topic.id}').remove();
  }

  static void updateTopic(Topic topic) => fb..ref('topics/${topic.id}').set(topic.toJson());

  static Future<Message> getLastMessage(Topic topic) async {
    Message ret;
    final event = await fb
        .ref('messages')
        .orderByChild('uid')
        .equalTo(userID)
        .limitToFirst(1)
        .once();
    final data = (event.snapshot.value as List<Map<String, dynamic>>)[0];
    ret = Message.fromJson(data, topic);
    return ret;
  }

  static Stream<DataSnapshot> getTopics() =>
      fb.ref('topics').orderByChild('uid').equalTo(userID).onValue.map((event) => event.snapshot);

  static void newMessage(Message newMessage) =>
      fb.ref('messages/${newMessage.uuid}').set(newMessage.toJson());

  static Stream<DataSnapshot> getTopicMessages(Topic topic) => fb
      .ref('messages')
      .orderByChild('uid')
      .equalTo(userID)
      .onValue
      .map((event) => event.snapshot);

  static Stream<DataSnapshot> loadTypeFavourites(int typeID) => fb
      .ref('messages')
      .orderByChild('uid')
      .equalTo(typeID)
      .onValue
      .map((event) => event.snapshot);

  static void deleteMessage(Message o) => fb.ref('messages/${o.uuid}').remove();

  static void updateMessage(Message o) => fb.ref('messages/${o.uuid}').set(o.toJson());

  static void deleteAllMessages(Topic topic) async {}
}
