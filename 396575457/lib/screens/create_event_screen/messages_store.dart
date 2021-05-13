import 'message.dart';

class EventsStore {
  final List<Message> _data = [
    Message('First Message'),
    Message('Second Message'),
    Message('Third Message'),
  ];

  List<Message> get eventsList {
    return _data;
  }

  int get size {
    return _data.length;
  }

  bool addMessage(String message) {
    _data.add(Message(message));
    return true;
  }

  bool addAlreadyCreateMessage(Message message) {
    _data.add(message);
    return true;
  }

  Message elementAt(int index) {
    return _data.elementAt(index);
  }

  bool removeElementAt(int index) {
    _data.removeAt(index);
    return true;
  }

  bool clear() {
    _data.clear();
    return true;
  }
}
