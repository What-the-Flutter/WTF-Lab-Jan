import '../create_event_screen/messages_store.dart';

import 'event.dart';

class EventData {
  final List<Event> _data = <Event>[
    Event(title: 'FirstEvent', messages: EventsStore()),
    Event(title: 'SecondEvent', messages: EventsStore()),
    Event(title: 'ThirdEvent', messages: EventsStore()),
  ];

  List<Event> get eventsList {
    return _data;
  }

  int get size {
    return _data.length;
  }

  bool putAlreadyCreateEvent(Event event) {
    _data.add(event);
    return true;
  }

  bool put(String title) {
    _data.add(Event(title: title));
    return true;
  }

  String getTitleByIndex(int i) {
    return _data.elementAt(i).titleString;
  }

  Event getEventByIndex(int i) {
    return _data[i];
  }

  bool removeEventByIndex(int i) {
    _data.removeAt(i);
    return true;
  }
}
