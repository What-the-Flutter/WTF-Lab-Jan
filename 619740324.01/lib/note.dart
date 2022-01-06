import 'event.dart';

class Note {
  List<Event> eventList = <Event>[];
  String eventName;
  int indexOfCircleAvatar;
  String subTittleEvent;

  Note({
    this.eventName = '',
    this.indexOfCircleAvatar = 0,
    this.subTittleEvent = 'Add event',
  });
}
