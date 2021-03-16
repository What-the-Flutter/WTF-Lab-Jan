import '../models/event.dart';
import '../models/event_type.dart';

abstract class IEventsRepository{
  List<EventType> getEventType();
  List<Event> getEventsList();
  void saveEventType(EventType eventType);
  void saveEvent(Event event);
}