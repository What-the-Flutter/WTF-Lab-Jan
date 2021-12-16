import 'dart:math';
import 'entities.dart';

class Event implements Message {
  @override
  Topic topic;

  String description;
  bool _isVisited = false;
  bool _isMissed = false;
  DateTime? scheduledTime;

  Event({required this.topic, required this.description, this.scheduledTime});

  void visit() {
    _isVisited = true;
    _isMissed = false;
  }

  void unVisit() => _isVisited = false;

  void miss() => _isMissed = true;

  bool isVisited() => _isVisited;

  bool isMissed() => _isMissed;

  int get uuid => hashCode + Random.secure().nextInt(100);

  static List<Event> getUpcomingEvents() {
    var toReturn = <Event>[];
    toReturn.add(
      Event(
        description: 'WTF Meeting',
        topic: Topic(name: 'WTF Lab'),
        scheduledTime: DateTime.parse('2012-02-27 13:27:00'),
      ),
    );
    toReturn.add(
      Event(
        description: 'First Exam',
        topic: Topic(name: 'BSUIR'),
        scheduledTime: DateTime.parse('2021-12-23 12:00:00'),
      ),
    );
    toReturn.add(
      Event(
        description: 'Tour to Japan',
        topic: Topic(name: 'Leisure'),
      ),
    );
    return toReturn;
  }

  static List<Message> getUpcomingEventsM() {
    var toReturn = <Message>[];
    toReturn.add(
      Event(
        description: 'WTF Meeting',
        topic: Topic(name: 'WTF Lab'),
        scheduledTime: DateTime.parse('2012-02-27 13:27:00'),
      ),
    );
    toReturn.add(
      Event(
        description: 'First Exam',
        topic: Topic(name: 'BSUIR'),
        scheduledTime: DateTime.parse('2021-12-23 12:00:00'),
      ),
    );
    toReturn.add(
        Event(description: 'Tour to Japan', topic: Topic(name: 'Leisure')));
    return toReturn;
  }
}
