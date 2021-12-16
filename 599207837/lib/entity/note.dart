import 'dart:math';

import 'entities.dart';

class Note implements Message {
  @override
  Topic topic;

  String? name;
  String description;
  DateTime? timeCreated;

  Note({required this.description, this.name, required this.topic}) {
    timeCreated = DateTime.now();
  }

  int get uuid => hashCode + Random.secure().nextInt(100);

  static List<Note> getNotes() {
    var toReturn = <Note>[];
    toReturn.add(
      Note(
        description:
            'Current Lesson\nhttps://flutterwtf.notion.site/layouts-31fc467b6b614b59bbfe648f482c1732',
        topic: Topic(name: 'WTF Lab'),
      ),
    );
    toReturn.add(
      Note(
        name: 'Previous Lesson',
        description:
            'https://flutterwtf.notion.site/3da5dd22f9e446dbbec634d154019bb1',
        topic: Topic(name: 'WTF Lab'),
      ),
    );
    toReturn.add(
      Note(
        name: 'Next Lesson',
        description: '',
        topic: Topic(name: 'WTF Lab'),
      ),
    );
    return toReturn;
  }

  static List<Message> getNotesM() {
    var toReturn = <Message>[];
    toReturn.add(
      Note(
        description:
            'Current Lesson\nhttps://flutterwtf.notion.site/layouts-31fc467b6b614b59bbfe648f482c1732',
        topic: Topic(name: 'WTF Lab'),
      ),
    );
    toReturn.add(
      Note(
        name: 'Previous Lesson',
        description:
            'https://flutterwtf.notion.site/3da5dd22f9e446dbbec634d154019bb1',
        topic: Topic(name: 'WTF Lab'),
      ),
    );
    toReturn.add(
      Note(
        name: 'Next Lesson',
        description: '',
        topic: Topic(name: 'WTF Lab'),
      ),
    );
    return toReturn;
  }
}
