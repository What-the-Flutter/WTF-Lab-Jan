import 'package:diary_in_chat_format_app/screens/home_screen/event.dart';

class EventData {
  List<Event> _data = <Event> [
    Event('FirstEvent'),
    Event('SecondEvent'),
    Event('ThirdEvent'),
  ];

  get receiveEventsList {
    return _data;
  }

  int size() {
    return _data.length;
  }
}