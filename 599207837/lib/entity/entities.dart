import 'dart:convert';

import 'package:intl/intl.dart';

import 'event.dart';
import 'note.dart';
import 'task.dart';
import 'topic.dart';

export 'event.dart';
export 'note.dart';
export 'task.dart';
export 'theme.dart';
export 'topic.dart';

DateFormat fullDateFormatter = DateFormat('d MMM y HH:mm');
DateFormat timeFormatter = DateFormat('HH:mm');

abstract class Message {
  late Topic topic;
  late DateTime timeCreated;
  late bool favourite;
  late String description;
  late String nodeID;
  late String? imgPath;

  void onFavourite();

  Message duplicate();

  int get uuid;

  Map<String, dynamic> toJson();

  static Message fromJson(Map<String, dynamic> json, Topic? topic, {String nodeID = ''}) {
    switch (json['type_id']) {
      case (0):
        return Task.fromJson(json, topic, nodeID: nodeID);
      case (1):
        return Event.fromJson(json, topic, nodeID: nodeID);
      default:
        return Note.fromJson(json, topic, nodeID: nodeID);
    }
  }

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

    final list = _allStringMatches(data, exp).toList().map((note) => _toJson(note));

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

int getTypeId(Message o) => o.runtimeType == Task ? 0 : (o.runtimeType == Event ? 1 : 2);
