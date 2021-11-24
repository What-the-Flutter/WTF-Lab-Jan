import 'models/event.dart';

class EventRepository {
  final List<Event> eventList = [];

  void addEvent(Event event) {
    eventList.add(event);
  }

  void deleteEvent(Event event) {
    eventList.remove(event);
  }

  void deleteEventByIndex(int index) {
    eventList.removeAt(index);
  }

  void insertEvent(int index, Event event) {
    eventList.insert(index, event);
  }

  List<Event> eventsListByPageId(int id) {
    return eventList.where((element) => element.pageId == id).toList();
  }

  List<Event> eventsList() {
    return eventList;
  }
}