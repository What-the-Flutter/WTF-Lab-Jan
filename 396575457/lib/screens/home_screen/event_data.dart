import 'event.dart';

class EventData {
  final List<Event> _data = <Event>[
    Event('FirstEvent'),
    Event('SecondEvent'),
    Event('ThirdEvent'),
  ];

  List<Event> get eventsList {
    return _data;
  }

  int get size {
    return _data.length;
  }

  String getTitleByIndex(int i) {
    return _data.elementAt(i).title;
  }
}
