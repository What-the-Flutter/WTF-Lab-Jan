import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import '../../entity/entities.dart';
import '../../main.dart';

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

  static Future<Message> fetchLastMessage(Topic topic) async {
    Message ret;
    final event =
        await fb.ref('messages').orderByChild('uid').equalTo(userID).limitToFirst(1).once();
    final data = (event.snapshot.value as List<Map<String, dynamic>>)[0];
    ret = Message.fromJson(data, topic);
    return ret;
  }

  static Stream<DataSnapshot> fetchTopics() =>
      fb.ref('topics').orderByChild('uid').equalTo(userID).onValue.map((event) => event.snapshot);

  static void newMessage(Message newMessage) =>
      fb.ref('messages/${newMessage.uuid}').set(newMessage.toJson());

  static Stream<DataSnapshot> fetchTopicMessages(Topic topic) =>
      fb.ref('messages').orderByChild('uid').equalTo(userID).onValue.map((event) => event.snapshot);

  static Stream<DataSnapshot> fetchTypeFavourites(int typeID) =>
      fb.ref('messages').orderByChild('uid').equalTo(typeID).onValue.map((event) => event.snapshot);

  static void deleteMessage(Message o) => fb.ref('messages/${o.uuid}').remove();

  static void updateMessage(Message o) => fb.ref('messages/${o.uuid}').set(o.toJson());

  static void deleteAllMessages(Topic topic) async {}

  static List<Map<String, dynamic>> parseData(String input) {
    final exp = RegExp(r'\d+: {[^}]+}');
    final expField = RegExp(r'[a-z_]+:');
    final value = RegExp(r': [\w-:\s\.]+,');

    final data = input.replaceAllMapped(expField, (match) {
      final field = match.group(0);
      return '"${field!.substring(0, field.length - 1)}":';
    }).replaceAllMapped(value, (match) {
      final temp = match.group(0);
      return ': "${temp!.substring(2, temp.length - 1)}",';
    }).replaceAllMapped(RegExp(r'"\d+"'), (match) {
      final temp = match.group(0);
      return '${temp!.substring(1, temp.length - 1)}';
    });
    print(data);

    final list = _allStringMatches(data, exp).toList().map(_toJson);

    for (var x in list) {
      print(x);
    }
    return list.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  static Iterable<String> _allStringMatches(String text, RegExp regExp) =>
      regExp.allMatches(text).map((m) => m.group(0)!);

  static String _toJson(String data) {
    final clear = data.substring(data.indexOf('{', 1) + 1, data.length - 1);
    return '{$clear}';
  }
}
